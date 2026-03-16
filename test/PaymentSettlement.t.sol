// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/PaymentSettlement.sol";
import "../contracts/InvoiceNFT.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor() ERC20("USDC", "USDC") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract PaymentSettlementTest is Test {
    PaymentSettlement public settlement;
    InvoiceNFT public invoiceNFT;
    MockToken public paymentToken;

    address public owner = address(this);
    address public payee = address(0x1);
    address public payer = address(0x2);
    address public admin = address(this);

    function setUp() public {
        paymentToken = new MockToken();
        invoiceNFT = new InvoiceNFT();
        settlement = new PaymentSettlement(address(invoiceNFT), address(paymentToken));
        invoiceNFT.grantRole(invoiceNFT.MINTER_ROLE(), admin);
    }

    function testSettleInvoicePayment() public {
        // Mint and send to payee
        uint256 invoiceId =
            invoiceNFT.mintInvoice(payee, "ipfs://", 1000 * 10 ** 18, 900 * 10 ** 18, block.timestamp + 30 days);

        // Prepare balances
        paymentToken.mint(payer, 1000 * 10 ** 18);
        assertEq(paymentToken.balanceOf(payee), 0);

        // Settlement execution
        vm.startPrank(payer);
        paymentToken.approve(address(settlement), 1000 * 10 ** 18);
        settlement.settleInvoicePayment(invoiceId, 1000 * 10 ** 18);
        vm.stopPrank();

        // Check if payee received the settlement funds
        assertEq(paymentToken.balanceOf(payee), 1000 * 10 ** 18);
        assertEq(paymentToken.balanceOf(payer), 0);
    }
}
