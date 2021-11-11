// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract UniverseNFT is
    ERC721URIStorage,
    ERC721Enumerable
{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    // Token CID card onchain
    mapping(uint256 => string) private _dataIdOnchains;

    // Token dataRegistrationProof onchain
    mapping(uint256 => string) private _dataRegistrationProofs;

    constructor() ERC721("Universe NFT", "UNIFT") {
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        ERC721URIStorage._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function getDataIdOnchain(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _dataIdOnchain = _dataIdOnchains[tokenId];
        string memory base = _baseURI();

        if (bytes(base).length == 0) {
            return _dataIdOnchain;
        }
        if (bytes(_dataIdOnchain).length > 0) {
            return string(abi.encodePacked(base, _dataIdOnchain));
        }
        return "";
    }

    function getDataRegistrationProof(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _dataRegistrationProof = _dataRegistrationProofs[tokenId];
        string memory base = _baseURI();

        if (bytes(base).length == 0) {
            return _dataRegistrationProof;
        }
        if (bytes(_dataRegistrationProof).length > 0) {
            return string(abi.encodePacked(base, _dataRegistrationProof));
        }
        return "";
    }

    function _setDataIdOnchain(uint256 tokenId, string memory dataIdOnchain) internal {
        _dataIdOnchains[tokenId] = dataIdOnchain;
    }

    function _setDataRegistrationProof(uint256 tokenId, string memory dataRegistrationProof) internal {
        _dataRegistrationProofs[tokenId] = dataRegistrationProof;
    }

    function mintDataNTF(address receiver, string memory tokenURIdata, string memory dataIdOnchain, string memory dataRegistrationProof)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(receiver, newItemId);
        _setTokenURI(newItemId, tokenURIdata);
        _setDataIdOnchain(newItemId, dataIdOnchain);
        _setDataRegistrationProof(newItemId, dataRegistrationProof);

        return newItemId;
    }
}