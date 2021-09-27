// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract UniversalNFT is
    ERC721URIStorage,
    ERC721Enumerable
{
    // Naming Counters contract by Counters.Counter so that _tokenIds can call functions in Counters contract
    using Counters for Counters.Counter;

    // _tokenIds has the data type of Struct Counter in Counters.sol
    Counters.Counter private _tokenIds;

    // Token CID card onchain
    mapping(uint256 => string) private _dataIdOnchains;

    // Token dataRegisterProof onchain
    mapping(uint256 => string) private _dataRegisterProofs;

    constructor() ERC721("Universal NFT", "UNS") {
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        ERC721URIStorage._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function totalSupply() public view override(ERC721Enumerable) returns (uint256) {
        return (_tokenIds.current());
    }

    function getDataIdOnchain(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _dataIdOnchain = _dataIdOnchains[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _dataIdOnchain;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_dataIdOnchain).length > 0) {
            return string(abi.encodePacked(base, _dataIdOnchain));
        }

        // TODO: return when base != "", _tokenCID == ""
        // return super.tokenURI(tokenId);
        return "";
    }

    function getDataRegisterProof(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _dataRegisterProof = _dataRegisterProofs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _dataRegisterProof;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_dataRegisterProof).length > 0) {
            return string(abi.encodePacked(base, _dataRegisterProof));
        }

        // TODO: return when base != "", _tokenCID == ""
        // return super.tokenURI(tokenId);
        return "";
    }

    function _setDataIdOnchain(uint256 tokenId, string memory dataIdOnchain) internal {
        _dataIdOnchains[tokenId] = dataIdOnchain;
    }

    function _setDataRegisterProof(uint256 tokenId, string memory dataRegisterProof) internal {
        _dataRegisterProofs[tokenId] = dataRegisterProof;
    }

    function mintDataNTF(address receiver, string memory tokenURIdata, string memory dataIdOnchain, string memory dataRegisterProof)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(receiver, newItemId);
        _setTokenURI(newItemId, tokenURIdata);
        _setDataIdOnchain(newItemId, dataIdOnchain);
        _setDataRegisterProof(newItemId, dataRegisterProof);

        return newItemId;
    }
}