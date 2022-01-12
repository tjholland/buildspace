// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// imports
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract MyEpicNFT is ERC721URIStorage {
    // help keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // pass the name of the NFTs token and its symbol
    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is the Travitron NFT contract!");
    }

    // function to get the NFT
    function makeAnEpicNFT() public {
        // get the current tokenId
        uint256 newItemId = _tokenIds.current();

        // mint the NFT
        _safeMint(msg.sender, newItemId);

        // set the NFT data, UPDATE JSON url!
        _setTokenURI(newItemId, "https://jsonkeeper.com/b/U1NG");
        console.log("AN NFT with ID %s has been minted to %s", newItemId, msg.sender);

        // increment the counter
        _tokenIds.increment();
    }
}