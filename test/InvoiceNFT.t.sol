// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/InvoiceNFT.sol";

contract InvoiceNFTTest is Test {
    InvoiceNFT public nft;
    address public admin = address(this);
    address public minter = address(0x1);
    address public business = address(0x2);

    function setUp() public {
        nft = new InvoiceNFT();
        nft.grantRole(nft.MINTER_ROLE(), minter);
    }

    function testMintInvoice() public {
        vm.prank(minter);
        uint256 id = nft.mintInvoice(business, "ipfs://hash", 1000, 900, block.timestamp + 30 days);

        assertEq(nft.ownerOf(id), business);
        assertEq(nft.tokenURI(id), "ipfs://hash");

        (uint256 faceValue, uint256 advanceAmount, uint256 dueDate, InvoiceNFT.InvoiceStatus status, address biz) =
            nft.invoices(id);
        assertEq(faceValue, 1000);
        assertEq(advanceAmount, 900);
        assertEq(uint256(status), uint256(InvoiceNFT.InvoiceStatus.Listed));
        assertEq(biz, business);
    }

    function testUpdateStatus() public {
        vm.startPrank(minter);
        uint256 id = nft.mintInvoice(business, "ipfs://hash", 1000, 900, block.timestamp + 30 days);
        nft.updateStatus(id, InvoiceNFT.InvoiceStatus.Financed);
        vm.stopPrank();

        (,,, InvoiceNFT.InvoiceStatus status,) = nft.invoices(id);
        assertTrue(uint256(status) == uint256(InvoiceNFT.InvoiceStatus.Financed));
    }

    function test_RevertIf_NoRole() public {
        vm.prank(business);
        vm.expectRevert();
        nft.mintInvoice(business, "ipfs://hash", 1000, 900, block.timestamp + 30 days);
    }

    function testSupportsInterface() public {
        assertTrue(nft.supportsInterface(0x80ac58cd)); // ERC721
    }
}
