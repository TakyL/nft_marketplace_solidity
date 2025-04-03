// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
/**
 * Each NFT's id is the hashed title 
 * @title 
 * @author 
 * @notice 
 */
contract NFTContract is ERC721Enumerable  {

    //Hash value of title song
    uint256 private hashTitleSong;

    constructor() ERC721("BABELES", "BBL") {
    }
    /**
     * @dev Mint a NFT
     * @param to Address user
     * @param name The song title
     */
    function mintTo(address to,string memory name) external {
       // Check if the token hans'nt already minted 
      uint256 tokenId = getTokenId(name);  
      require(_ownerOf(tokenId) == address(0), "Token already minted");
      _mint(to,tokenId);  
    }

    /**
     * @dev Hash the title for the id using keccak256
     * @param input Title's song i.e "Bonjour"
     * @return hashedValue of the song
     */
    function getTokenId(string memory input) public pure  returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

}