// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract UniversalNFT is ERC721URIStorage {
    // Naming Counters contract by Counters.Counter so that _tokenIds can call functions in Counters contract
    using Counters for Counters.Counter;

    // _tokenIds has the data type of Struct Counter in Counters.sol
    Counters.Counter private _tokenIds;

    // Token CID card onchain
    mapping(uint256 => string) private _tokenCIDs;

    // Token dataRegisterProof onchain
    mapping(uint256 => string) private _tokenDataProofs;

    constructor() ERC721("Universal NFT", "UNS") {}

    function tokenCID(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _tokenCID = _tokenCIDs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenCID;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenCID).length > 0) {
            return string(abi.encodePacked(base, _tokenCID));
        }

        // TODO: return when base != "", _tokenCID == ""
        // return super.tokenURI(tokenId);
        return "";
    }

    function _setTokenCID(uint256 tokenId, string memory _tokenCID) internal {
        require(_exists(tokenId), "ERC721URIStorage: CID set of nonexistent token");
        _tokenCIDs[tokenId] = _tokenCID;
    }

    function mintUniversalNTF(address player, string memory tokenURI, string memory cardCID)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);
        _setTokenCID(newItemId, cardCID);

        return newItemId;
    }
}