// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/InvoiceMarketplace.sol";
import "../contracts/InvoiceNFT.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockPaymentToken is ERC20 {
    constructor() ERC20("Mock Token", "MTK") {
        _mint(msg.sender, 1000000 * 10 ** 18);
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract InvoiceMarketplaceTest is Test {
    InvoiceMarketplace public marketplace;
    InvoiceNFT public invoiceNFT;
    MockPaymentToken public paymentToken;

    address public seller = address(0x1);
    address public buyer = address(0x2);
    address public admin = address(this);

    function setUp() public {
        paymentToken = new MockPaymentToken();
        invoiceNFT = new InvoiceNFT();
        marketplace = new InvoiceMarketplace(address(invoiceNFT), address(paymentToken));

        invoiceNFT.grantRole(invoiceNFT.MINTER_ROLE(), admin);

        // Setup seller
        paymentToken.mint(seller, 10000 * 10 ** 18);
        vm.deal(seller, 10 ether);

        // Setup buyer
        paymentToken.mint(buyer, 10000 * 10 ** 18);
        vm.deal(buyer, 10 ether);
    }

    function testListingAndBuying() public {
        // Mint NFT to seller
        uint256 invoiceId = invoiceNFT.mintInvoice(seller, "ipfs://test", 1000 * 10 ** 18, 900 * 10 ** 18, block.timestamp + 30 days);
        
        // Seller lists it
        vm.startPrank(seller);
        invoiceNFT.approve(address(marketplace), invoiceId);
        marketplace.listInvoice(invoiceId, 500 * 10 ** 18);
        vm.stopPrank();

        (uint256 id, address listSeller, uint256 price, bool active) = marketplace.listings(invoiceId);
        assertEq(id, invoiceId);
        assertEq(listSeller, seller);
        assertEq(price, 500 * 10 ** 18);
        assertTrue(active);
        assertEq(invoiceNFT.ownerOf(invoiceId), address(marketplace));

        // Buyer buys it
        vm.startPrank(buyer);
        paymentToken.approve(address(marketplace), 500 * 10 ** 18);
        marketplace.buyInvoice(invoiceId);
        vm.stopPrank();

        // Check ownership and balances
        assertEq(invoiceNFT.ownerOf(invoiceId), buyer);
        assertEq(paymentToken.balanceOf(seller), 10500 * 10 ** 18); // 10000 + 500
        assertEq(paymentToken.balanceOf(buyer), 9500 * 10 ** 18);  // 10000 - 500
        
        (, , , bool finalActive) = marketplace.listings(invoiceId);
        assertFalse(finalActive);
    }
}
