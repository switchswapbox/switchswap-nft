// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract UniversalSwapNFT is
    IERC721Receiver 
{
    using SafeMath for uint256;

    // NFT price storage:
    // address of external contract -> owner address -> external tokenID -> price
    mapping (address => mapping (address => mapping(uint256 => uint256))) public _dataToken;

    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function depositToken(address tokenContract, uint256 externalTokenID, uint256 price)
        public
        payable
    {
        require(tokenContract != address(0x0), "Invalide token");
        require(price > 0, "Invalide price");
        require(ERC721(tokenContract).ownerOf(externalTokenID) == msg.sender, "Only token's owner");
        ERC721(tokenContract).safeTransferFrom(msg.sender, address(this), externalTokenID);
        _dataToken[tokenContract][msg.sender][externalTokenID] = price;
    }


    function withdrawToken(address tokenContract, uint256 externalTokenID)
        public
        payable
    {
        require(tokenContract != address(0x0), "Invalide token");
        require(_dataToken[tokenContract][msg.sender][externalTokenID] != 0, "Only token's owner");
        _dataToken[tokenContract][msg.sender][externalTokenID] = 0;
        ERC721(tokenContract).safeTransferFrom(address(this), msg.sender, externalTokenID);
    }

    function getTokenPrice(address tokenContract, address currentOwner, uint256 externalTokenID)
        public
        view
        returns (uint256)
    {
        uint256 price = _dataToken[tokenContract][currentOwner][externalTokenID];
        require(price > 0, "Token invalide or has been withdrawn!");
        return price;
    }

    function setTokenPrice(address tokenContract, uint256 externalTokenID, uint256 _newPrice)
        public
    {
        require(_dataToken[tokenContract][msg.sender][externalTokenID] > 0, "You are not the owner of the token");
        require(_newPrice > 0);
        _dataToken[tokenContract][msg.sender][externalTokenID] = _newPrice;
    }

    function purchaseToken(address tokenContract, uint256 externalTokenID, address currentOwner)
        public
        payable 
    {
        require(msg.sender != address(0) && msg.sender != address(this), "Purchase not allowed");
        require(_dataToken[tokenContract][currentOwner][externalTokenID] > 0, "Token non exists or not in sale!");
        require(msg.value >= _dataToken[tokenContract][currentOwner][externalTokenID], "Amount invalide!");
        ERC721(tokenContract).safeTransferFrom(address(this), msg.sender, externalTokenID);
        (bool success, ) = currentOwner.call{value: _dataToken[tokenContract][currentOwner][externalTokenID]}("");
        require(success, "Transfer failed.");
    }
}