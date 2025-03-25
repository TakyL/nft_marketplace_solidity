// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/contracts/Nft.sol";

contract CustomNFTTest is Test {
    NFTContract nft;

    function setUp() public {
        nft = new NFTContract();
    }

    /**
     * Check if the owner of the token minted is correct
     */
    function testNFTOwnerof() public {
        address recipient = address(0x123);
        nft.mint(recipient, "bonjour");

        uint256 tokenId = nft.getTokenId("bonjour");
        assertEq(
            nft.ownerOf(tokenId),
            recipient,
            "Recipient should own the minted token"
        );

    }
    /**
     * Check if the same nft cannot be minted multiples times
     */
    function testAlreadyOwned() public {
        address recipient = address(0x123);
        nft.mint(recipient, "bonjour");
        vm.expectRevert("Token already minted");
        nft.mint(recipient, "bonjour");
    }

    /**
     * Check if an owner can owns multiples nft
     */
    function testNFTOwnerofmultiples() public {
        address recipient = address(0x123);
        nft.mint(recipient, "bonjour");
        nft.mint(recipient, "bonjour2");
        nft.mint(recipient, "bonjour3");
        uint256 tokenId = nft.getTokenId("bonjour");
        uint256 tokenId2 = nft.getTokenId("bonjour2");
        uint256 tokenId3 = nft.getTokenId("bonjour3");

        assertEq(
            nft.ownerOf(tokenId),
            recipient,
            "Recipient should own the minted token : bonjour"
        );
        assertEq(
            nft.ownerOf(tokenId2),
            recipient,
            "Recipient should own the minted token : bonjour2"
        );
        assertEq(
            nft.ownerOf(tokenId3),
            recipient,
            "Recipient should own the minted token : bonjour3"
        );
    }


}
