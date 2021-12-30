// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract UniversalNFT is
    AccessControlEnumerable,
    ERC721Enumerable,
    ERC721Burnable,
    ERC721URIStorage
{
    // Naming Counters contract by Counters.Counter so that _tokenIds can call functions in Counters contract
    using Counters for Counters.Counter;

    // _tokenIds has the data type of Struct Counter in Counters.sol
    Counters.Counter private _tokenIds;

    // Token CID card onchain
    mapping(uint256 => string) private _dataIdOnchains;

    // Token dataRegisterProof onchain
    mapping(uint256 => string) private _dataRegisterProofs;

    // NFT storage:
    mapping (uint => uint256) public _dataTokenPrice;

    // Balance storage:
    mapping (address => uint256) public _balances;

    constructor() ERC721("Universal NFT", "UNS") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function totalSupply() public view override(ERC721Enumerable) returns (uint256) {
        return (_tokenIds.current());
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControlEnumerable, ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
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
        _dataTokenPrice[newItemId] = 0;

        return newItemId;
    }

    function withdraw()
        public
        payable
    {
        uint balance = address(this).balance;
        require(balance > 0, "No money left to withdraw");
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed.");
    }

    function getTokenPrice(uint256 _tokenId)
        view public returns(uint256)
    {
        require(_exists(_tokenId), "ERC721URIStorage: URI query for nonexistent token");
        return _dataTokenPrice[_tokenId];
    }

    function setTokenPrice(uint256 _tokenId, uint256 _newPrice)
        public
    {
        require(_exists(_tokenId), "ERC721URIStorage: URI query for nonexistent token");
        require(msg.sender == ownerOf(_tokenId), "You are not the owner of the token");
        require(_newPrice > 0);
        _dataTokenPrice[_tokenId] = _newPrice;
    }

    function purchaseToken(uint256 _tokenId)
        public
        payable 
    {
        require(msg.sender != address(0) && msg.sender != address(this), "Purchase not allowed");
        require(msg.value >= _dataTokenPrice[_tokenId], "Insufisent balance!");
        require(_exists(_tokenId));
        address tokenSeller = ownerOf(_tokenId);
        safeTransferFrom(tokenSeller, msg.sender, _tokenId);
        // emit Received(msg.sender, _tokenId, msg.value, address(this).balance);
    }
}