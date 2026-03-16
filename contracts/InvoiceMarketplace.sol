// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./InvoiceNFT.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

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
    event ListingCancelled(uint256 indexed invoiceId, address indexed seller);
    event ListingPriceUpdated(uint256 indexed invoiceId, uint256 newPrice);

    error NotOwner();
    error InvalidPrice();
    error NotListed();
    error PaymentFailed();
    error NotSeller();

    constructor(address _invoiceNFT, address _paymentToken) {
        invoiceNFT = InvoiceNFT(_invoiceNFT);
        paymentToken = IERC20(_paymentToken);
    }

    function listInvoice(uint256 invoiceId, uint256 price) external {
        if (invoiceNFT.ownerOf(invoiceId) != msg.sender) revert NotOwner();
        if (price == 0) revert InvalidPrice();

        invoiceNFT.transferFrom(msg.sender, address(this), invoiceId);

        listings[invoiceId] = Listing({invoiceId: invoiceId, seller: msg.sender, price: price, active: true});

        emit InvoiceListed(invoiceId, msg.sender, price);
    }

    function buyInvoice(uint256 invoiceId) external nonReentrant {
        Listing storage listing = listings[invoiceId];
        if (!listing.active) revert NotListed();

        listing.active = false;

        if (!paymentToken.transferFrom(msg.sender, listing.seller, listing.price)) revert PaymentFailed();
        invoiceNFT.transferFrom(address(this), msg.sender, invoiceId);

        emit InvoiceSold(invoiceId, msg.sender, listing.price);
    }

    function cancelListing(uint256 invoiceId) external nonReentrant {
        Listing storage listing = listings[invoiceId];
        if (!listing.active) revert NotListed();
        if (listing.seller != msg.sender) revert NotSeller();

        listing.active = false;
        invoiceNFT.transferFrom(address(this), msg.sender, invoiceId);

        emit ListingCancelled(invoiceId, msg.sender);
    }

    function updateListingPrice(uint256 invoiceId, uint256 newPrice) external {
        Listing storage listing = listings[invoiceId];
        if (!listing.active) revert NotListed();
        if (listing.seller != msg.sender) revert NotSeller();
        if (newPrice == 0) revert InvalidPrice();

        listing.price = newPrice;
        emit ListingPriceUpdated(invoiceId, newPrice);
    }
}
