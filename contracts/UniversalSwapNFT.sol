// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract UniversalSwapNFT is
    AccessControlEnumerable
{
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    // NFT price storage:
    // address of external contract -> owner address -> price
    mapping (address => mapping (address => uint256)) public _dataToken;

    function onERC721Received(address, address, uint256, bytes calldata)
        external pure
    returns (bytes4)
    {
        return bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
    }

    function depositToken(address token, uint256 externalTokenID, uint256 price)
        public
        payable
    {
        require(token != address(0x0), "Invalide token");
        require(price > 0, "Invalide price");
        require(ERC721(token).ownerOf(externalTokenID) == msg.sender, "You are not the owner of this token");
        ERC721(token).safeTransferFrom(msg.sender, address(this), externalTokenID);

        _dataToken[token][msg.sender] = price;
    }

    // function withdrawToken(address token, uint256 externalTokenID)
    //     public
    //     payable
    // {
    //     require(token != address(0x0), "Invalide token");
    //     require(_dataToken[token][msg.sender] != 0, "You are not the owner of this token");
    //     _dataToken[token][msg.sender] = 0;
    //     ERC721(token).safeTransferFrom(msg.sender, externalTokenID);
    // }

    // function getTokenPrice(uint256 _tokenId)
    //     view public returns(uint256)
    // {
    //     require(_exists(_tokenId), "ERC721URIStorage: URI query for nonexistent token");
    //     return _dataTokenPrice[_tokenId];
    // }

    // function setTokenPrice(uint256 _tokenId, uint256 _newPrice)
    //     public
    // {
    //     require(_exists(_tokenId), "ERC721URIStorage: URI query for nonexistent token");
    //     require(msg.sender == ownerOf(_tokenId), "You are not the owner of the token");
    //     require(_newPrice > 0);
    //     _dataTokenPrice[_tokenId] = _newPrice;
    // }

    // function purchaseToken(uint256 _tokenId)
    //     public
    //     payable 
    // {
    //     require(msg.sender != address(0) && msg.sender != address(this), "Purchase not allowed");
    //     require(msg.value >= _dataTokenPrice[_tokenId], "Insufisent balance!");
    //     require(_exists(_tokenId));
    //     address tokenSeller = ownerOf(_tokenId);
    //     _transfer(tokenSeller, msg.sender, _tokenId);
    //     (bool success, ) = tokenSeller.call{value: _dataTokenPrice[_tokenId]}("");
    //     require(success, "Transfer failed.");
    // }
}