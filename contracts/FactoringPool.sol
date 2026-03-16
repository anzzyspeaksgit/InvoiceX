// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@shared/contracts/BaseRWA.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./InvoiceNFT.sol";

/**
 * @title FactoringPool
 * @dev Pooled liquidity for invoice factoring. Users deposit stablecoins to receive INVX-POOL tokens.
 * These funds are used to buy invoices at a discount (advance amount).
 * When invoices are repaid at face value, the pool value increases.
 */
contract FactoringPool is BaseRWA {
    using SafeERC20 for IERC20;

    IERC20 public stablecoin;
    InvoiceNFT public invoiceNFT;

    uint256 public totalPoolValue; // In stablecoin decimals
    uint256 public constant PRECISION = 1e18;

    event Deposited(address indexed user, uint256 amount, uint256 poolTokens);
    event Withdrawn(address indexed user, uint256 poolTokens, uint256 amount);
    event InvoiceFinanced(uint256 indexed tokenId, uint256 advanceAmount);
    event InvoiceRepaid(uint256 indexed tokenId, uint256 faceValue);

    constructor(address _stablecoin, address _invoiceNFT)
        BaseRWA("InvoiceX Pool Token", "INVX-POOL", "INVOICE_FACTORING_POOL")
    {
        stablecoin = IERC20(_stablecoin);
        invoiceNFT = InvoiceNFT(_invoiceNFT);
        requiresKYC = true; // Business and investors need KYC
    }

    /**
     * @notice Deposit stablecoins to provide liquidity
     */
    function deposit(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be > 0");
        require(isWhitelisted[msg.sender] || !requiresKYC, "KYC required");

        uint256 currentPrice = getAssetPrice();
        uint256 sharesToMint = (amount * PRECISION) / currentPrice;

        stablecoin.safeTransferFrom(msg.sender, address(this), amount);

        totalPoolValue += amount;
        _mint(msg.sender, sharesToMint);

        emit Deposited(msg.sender, amount, sharesToMint);
    }

    /**
     * @notice Withdraw stablecoins by burning pool tokens
     */
    function withdraw(uint256 shares) external nonReentrant {
        require(shares > 0, "Shares must be > 0");
        require(balanceOf(msg.sender) >= shares, "Insufficient balance");

        uint256 currentPrice = getAssetPrice();
        uint256 amountToReturn = (shares * currentPrice) / PRECISION;

        require(stablecoin.balanceOf(address(this)) >= amountToReturn, "Insufficient liquidity");

        totalPoolValue -= amountToReturn;
        _burn(msg.sender, shares);

        stablecoin.safeTransfer(msg.sender, amountToReturn);

        emit Withdrawn(msg.sender, shares, amountToReturn);
    }

    /**
     * @notice Finance an invoice from the pool
     */
    function financeInvoice(uint256 tokenId) external onlyRole(DEFAULT_ADMIN_ROLE) nonReentrant {
        require(invoiceNFT.ownerOf(tokenId) != address(0), "Invoice not minted");
        (, uint256 advanceAmount,, InvoiceNFT.InvoiceStatus status, address business) = invoiceNFT.invoices(tokenId);

        require(status == InvoiceNFT.InvoiceStatus.Listed, "Invoice not listed");
        require(stablecoin.balanceOf(address(this)) >= advanceAmount, "Insufficient liquidity");

        // Transfer NFT to the pool (requires business to have approved the pool)
        invoiceNFT.transferFrom(business, address(this), tokenId);

        // Update status
        invoiceNFT.updateStatus(tokenId, InvoiceNFT.InvoiceStatus.Financed);

        // Send advance amount to business
        stablecoin.safeTransfer(business, advanceAmount);

        // Note: Total pool value doesn't drop immediately; the "advanceAmount" is replaced by the "faceValue" expected return
        // but to be safe with MTM, pool value should track cash + expected returns.
        // For simplicity, we add the difference to totalPoolValue upon repayment.

        emit InvoiceFinanced(tokenId, advanceAmount);
    }

    /**
     * @notice Repay an invoice (typically called by business or payer)
     */
    function repayInvoice(uint256 tokenId) external nonReentrant {
        (uint256 faceValue, uint256 advanceAmount,, InvoiceNFT.InvoiceStatus status,) = invoiceNFT.invoices(tokenId);

        require(status == InvoiceNFT.InvoiceStatus.Financed, "Invoice not financed");
        require(invoiceNFT.ownerOf(tokenId) == address(this), "Pool does not own invoice");

        // Transfer face value from payer to pool
        stablecoin.safeTransferFrom(msg.sender, address(this), faceValue);

        // The yield is the difference between faceValue and advanceAmount
        uint256 yieldEarned = faceValue - advanceAmount;
        totalPoolValue += yieldEarned;

        // Update status
        invoiceNFT.updateStatus(tokenId, InvoiceNFT.InvoiceStatus.Repaid);

        emit InvoiceRepaid(tokenId, faceValue);
    }

    /**
     * @notice Mark an invoice as defaulted, writing off the advance amount
     */
    function markDefaulted(uint256 tokenId) external onlyRole(DEFAULT_ADMIN_ROLE) nonReentrant {
        (, uint256 advanceAmount,, InvoiceNFT.InvoiceStatus status,) = invoiceNFT.invoices(tokenId);

        require(status == InvoiceNFT.InvoiceStatus.Financed, "Invoice not financed");
        require(invoiceNFT.ownerOf(tokenId) == address(this), "Pool does not own invoice");

        // Write down the pool value by the lost advance amount
        if (totalPoolValue > advanceAmount) {
            totalPoolValue -= advanceAmount;
        } else {
            totalPoolValue = 0;
        }

        invoiceNFT.updateStatus(tokenId, InvoiceNFT.InvoiceStatus.Defaulted);
    }

    /**
     * @notice BaseRWA override
     */
    function getAssetPrice() public view override returns (uint256) {
        uint256 totalShares = totalSupply();
        if (totalShares == 0) return PRECISION; // 1:1 initially
        return (totalPoolValue * PRECISION) / totalShares;
    }

    /**
     * @notice BaseRWA override
     * We assume the pool is 100% collateralized by stablecoins + financed invoices
     */
    function getCollateralizationRatio() public pure override returns (uint256) {
        return 10000; // 100% in bps
    }
}
