// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./InvoiceNFT.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract InvoiceMarketplace is ReentrancyGuard {
    InvoiceNFT public invoiceNFT;
    IERC20 public paymentToken;

    struct Listing {
        uint256 invoiceId;
        address seller;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;

    event InvoiceListed(uint256 indexed invoiceId, address indexed seller, uint256 price);
    event InvoiceSold(uint256 indexed invoiceId, address indexed buyer, uint256 price);

    constructor(address _invoiceNFT, address _paymentToken) {
        invoiceNFT = InvoiceNFT(_invoiceNFT);
        paymentToken = IERC20(_paymentToken);
    }

    function listInvoice(uint256 invoiceId, uint256 price) external {
        require(invoiceNFT.ownerOf(invoiceId) == msg.sender, "Not the owner");
        require(price > 0, "Price must be greater than 0");

        invoiceNFT.transferFrom(msg.sender, address(this), invoiceId);

        listings[invoiceId] = Listing({
            invoiceId: invoiceId,
            seller: msg.sender,
            price: price,
            active: true
        });

        emit InvoiceListed(invoiceId, msg.sender, price);
    }

    function buyInvoice(uint256 invoiceId) external nonReentrant {
        Listing storage listing = listings[invoiceId];
        require(listing.active, "Not listed for sale");

        listing.active = false;
        
        require(paymentToken.transferFrom(msg.sender, listing.seller, listing.price), "Payment failed");
        invoiceNFT.transferFrom(address(this), msg.sender, invoiceId);

        emit InvoiceSold(invoiceId, msg.sender, listing.price);
    }
}
