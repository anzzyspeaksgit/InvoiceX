// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./InvoiceNFT.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PaymentSettlement is Ownable {
    InvoiceNFT public invoiceNFT;
    IERC20 public paymentToken;

    event PaymentSettled(uint256 indexed invoiceId, address indexed payee, uint256 amount);

    error SettlementFailed();

    constructor(address _invoiceNFT, address _paymentToken) Ownable(msg.sender) {
        invoiceNFT = InvoiceNFT(_invoiceNFT);
        paymentToken = IERC20(_paymentToken);
    }

    function settleInvoicePayment(uint256 invoiceId, uint256 amount) external {
        address currentOwner = invoiceNFT.ownerOf(invoiceId);
        if (!paymentToken.transferFrom(msg.sender, currentOwner, amount)) revert SettlementFailed();

        emit PaymentSettled(invoiceId, currentOwner, amount);
    }
}
