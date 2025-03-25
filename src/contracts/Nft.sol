// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
/**
 * Each NFT a pour valeur le hash du nom de la musique+nom auteur
 * @title 
 * @author 
 * @notice 
 */
contract NFTContract is ERC721Enumerable  {

    //Hash value of title song
    uint256 private hashTitleSong;

    constructor() ERC721("BABELES", "BBL") {
    }

    function mint(address to,string memory name) external {
       // Check if the token hanb'nt already minted 
      uint256 tokenId = getTokenId(name);  // Get the next token ID
      require(_ownerOf(tokenId) == address(0), "Token already minted");
      _mint(to,tokenId);  // Mint the token with the generated id
      
    }

        // Function to hash a string
    function getTokenId(string memory input) public pure  returns (uint256) {
        // Hash the input string using keccak256
        return uint256(keccak256(abi.encodePacked(input)));
    }

}