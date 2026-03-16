// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/FactoringPool.sol";
import "../contracts/InvoiceNFT.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockStablecoin is ERC20 {
    constructor() ERC20("Mock USD", "mUSD") {
        _mint(msg.sender, 1000000 * 10 ** 18);
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract FactoringPoolTest is Test {
    FactoringPool public pool;
    InvoiceNFT public invoiceNFT;
    MockStablecoin public stablecoin;

    address public admin = address(this);
    address public investor = address(0x1);
    address public business = address(0x2);
    address public payer = address(0x3);

    function setUp() public {
        stablecoin = new MockStablecoin();
        invoiceNFT = new InvoiceNFT();

        // Mock BaseRWA constructor requirements might need to be adjusted based on implementation
        pool = new FactoringPool(address(stablecoin), address(invoiceNFT));

        // Setup roles
        invoiceNFT.grantRole(invoiceNFT.MINTER_ROLE(), admin);
        invoiceNFT.grantRole(invoiceNFT.MINTER_ROLE(), address(pool)); // So pool can update status

        pool.whitelistInvestor(investor);
        pool.whitelistInvestor(business);
        pool.whitelistInvestor(address(pool));

        // Setup investor funds
        stablecoin.mint(investor, 10000 * 10 ** 18);
        vm.prank(investor);
        stablecoin.approve(address(pool), 10000 * 10 ** 18);

        // Setup payer funds
        stablecoin.mint(payer, 10000 * 10 ** 18);
        vm.prank(payer);
        stablecoin.approve(address(pool), 10000 * 10 ** 18);
    }

    function testDeposit() public {
        vm.prank(investor);
        pool.deposit(1000 * 10 ** 18);

        assertEq(pool.balanceOf(investor), 1000 * 10 ** 18);
        assertEq(pool.totalPoolValue(), 1000 * 10 ** 18);
        assertEq(stablecoin.balanceOf(address(pool)), 1000 * 10 ** 18);
    }

    function testWithdraw() public {
        vm.startPrank(investor);
        pool.deposit(1000 * 10 ** 18);
        pool.withdraw(500 * 10 ** 18);
        vm.stopPrank();

        assertEq(pool.balanceOf(investor), 500 * 10 ** 18);
        assertEq(pool.totalPoolValue(), 500 * 10 ** 18);
    }

    function testFinanceInvoice() public {
        // Pool gets liquidity
        vm.prank(investor);
        pool.deposit(2000 * 10 ** 18);

        // Mint NFT
        uint256 invoiceId =
            invoiceNFT.mintInvoice(business, "ipfs://", 1000 * 10 ** 18, 900 * 10 ** 18, block.timestamp + 30 days);

        // Business approves pool
        vm.prank(business);
        invoiceNFT.approve(address(pool), invoiceId);

        // Finance
        pool.financeInvoice(invoiceId);

        assertEq(invoiceNFT.ownerOf(invoiceId), address(pool));
        assertEq(stablecoin.balanceOf(business), 900 * 10 ** 18); // Received advance

        (,,, InvoiceNFT.InvoiceStatus status,) = invoiceNFT.invoices(invoiceId);
        assertEq(uint256(status), uint256(InvoiceNFT.InvoiceStatus.Financed));
    }

    function testRepayInvoice() public {
        // Setup state to be financed
        vm.prank(investor);
        pool.deposit(2000 * 10 ** 18);

        uint256 invoiceId =
            invoiceNFT.mintInvoice(business, "ipfs://", 1000 * 10 ** 18, 900 * 10 ** 18, block.timestamp + 30 days);

        vm.prank(business);
        invoiceNFT.approve(address(pool), invoiceId);

        pool.financeInvoice(invoiceId);

        uint256 preRepayPoolValue = pool.totalPoolValue();

        // Repay
        vm.prank(payer);
        pool.repayInvoice(invoiceId);

        assertEq(pool.totalPoolValue(), preRepayPoolValue + 100 * 10 ** 18); // earned yield

        (,,, InvoiceNFT.InvoiceStatus status,) = invoiceNFT.invoices(invoiceId);
        assertEq(uint256(status), uint256(InvoiceNFT.InvoiceStatus.Repaid));
    }

    function testMarkDefaulted() public {
        vm.prank(investor);
        pool.deposit(2000 * 10 ** 18);

        uint256 invoiceId =
            invoiceNFT.mintInvoice(business, "ipfs://", 1000 * 10 ** 18, 900 * 10 ** 18, block.timestamp + 30 days);

        vm.prank(business);
        invoiceNFT.approve(address(pool), invoiceId);

        pool.financeInvoice(invoiceId);
        uint256 preDefaultPoolValue = pool.totalPoolValue();

        pool.markDefaulted(invoiceId);

        assertEq(pool.totalPoolValue(), preDefaultPoolValue - 900 * 10 ** 18); // lost advance

        (,,, InvoiceNFT.InvoiceStatus status,) = invoiceNFT.invoices(invoiceId);
        assertEq(uint256(status), uint256(InvoiceNFT.InvoiceStatus.Defaulted));
    }
}
