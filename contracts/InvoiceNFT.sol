// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title InvoiceNFT
 * @dev Represents an individual business invoice tokenized as an NFT.
 */
contract InvoiceNFT is ERC721URIStorage, AccessControl {
    uint256 private _tokenIds;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    enum InvoiceStatus {
        Listed,
        Financed,
        Repaid,
        Defaulted
    }

    struct InvoiceDetails {
        uint256 faceValue;
        uint256 advanceAmount;
        uint256 dueDate;
        InvoiceStatus status;
        address business;
    }

    mapping(uint256 => InvoiceDetails) public invoices;

    event InvoiceMinted(
        uint256 indexed tokenId, address indexed business, uint256 faceValue, uint256 advanceAmount, uint256 dueDate
    );
    event InvoiceStatusChanged(uint256 indexed tokenId, InvoiceStatus newStatus);

    constructor() ERC721("InvoiceX NFT", "INVX") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    /**
     * @notice Mints a new Invoice NFT
     */
    function mintInvoice(address business, string memory uri, uint256 faceValue, uint256 advanceAmount, uint256 dueDate)
        external
        onlyRole(MINTER_ROLE)
        returns (uint256)
    {
        _tokenIds++;
        uint256 newItemId = _tokenIds;

        _mint(business, newItemId);
        _setTokenURI(newItemId, uri);

        invoices[newItemId] = InvoiceDetails({
            faceValue: faceValue,
            advanceAmount: advanceAmount,
            dueDate: dueDate,
            status: InvoiceStatus.Listed,
            business: business
        });

        emit InvoiceMinted(newItemId, business, faceValue, advanceAmount, dueDate);

        return newItemId;
    }

    /**
     * @notice Updates the status of an invoice
     */
    function updateStatus(uint256 tokenId, InvoiceStatus newStatus) external onlyRole(MINTER_ROLE) {
        _requireOwned(tokenId);
        invoices[tokenId].status = newStatus;
        emit InvoiceStatusChanged(tokenId, newStatus);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
