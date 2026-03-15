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

    function setUp() public {
        paymentToken = new MockToken();
        invoiceNFT = new InvoiceNFT();
        settlement = new PaymentSettlement(address(invoiceNFT), address(paymentToken));
    }

    function testSettleInvoicePayment() public {
        // Prepare balances
        paymentToken.mint(payer, 1000 * 10**18);
        vm.prank(payer);
        paymentToken.approve(address(settlement), 1000 * 10**18);

        // Assume invoiceNFT minted and transferred to payee
        // invoiceNFT.mintInvoice(payee, "ipfs://", 1000 * 10**18);
        // assertEq(paymentToken.balanceOf(payee), 0);
        // vm.prank(payer);
        // settlement.settleInvoicePayment(1, 1000 * 10**18);
        // assertEq(paymentToken.balanceOf(payee), 1000 * 10**18);
    }
}
