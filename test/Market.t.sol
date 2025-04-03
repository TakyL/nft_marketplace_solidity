// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/contracts/Market.sol";
import "../src/contracts/Nft.sol";
import "../src/contracts/struct/Offer.sol";

contract MarketTest is Test {
    MarketPlace market;
    NFTContract nft;
    address owner = makeAddr("owner");
    address shop = makeAddr("shop");

    function setUp() public {
        nft = new NFTContract();
        market = new MarketPlace(nft);
    }

    constructor() {}

    /**
     * @dev Check if the NFT has been added
     * Check the followings asserts : 
     * - Balance is deducted for the fee
     * - The sender has a nft in the market's list
     */
    function testAddNFT() public {
        address bob = address(0x1564646485);
        vm.prank(bob);
        vm.deal(bob, 5 ether);

        market.addNFT{value: 5 ether}("chanson");
        uint256 resultBalance = bob.balance;

        assertEq(
            resultBalance,
            0 ether,
            "Balance should be reduced by 5 ether"
        );
        vm.prank(bob);
        assertEq(
            market.getMyNFTs().length,
            1,
            "The list of NFTs that the address should have is 1"
        );
    }

    /**
     * @dev Check if the sender's can't add a NFT if the balance is incorrect
     */
    function testInsuffiantAmount() public {
        address bob = address(0x1564646485);
        vm.prank(bob);
        vm.deal(bob, 5 ether);
        vm.expectRevert("Insufficient funds to cover the fee");
        market.addNFT{value: 4 ether}("chanson");
    }
    /**
     * @dev Check if the sender's balanced has been refound if he sent more token than needed
     */
    function testRefoundIfExcess() public {
        address bob = address(0x1564646485);
        vm.prank(bob);
        vm.deal(bob, 8 ether);

        market.addNFT{value: 8 ether}("chanson");
        uint256 resultBalance = bob.balance;
        assertEq(resultBalance, 3 ether, "Balance should be 3 ether, refund 3");
        assertEq(
            market.getUserNFTs(bob).length,
            1,
            "The list of NFTs that the address should have is 1"
        );
    }

    /**
     * @dev Check if the remove's function works
     * - The user's list should be deducted 
     * - The balance should be 0 (if initial is 5)
     */
    function testRemoveNFT() public {
        address bob = address(0x1564646485);
        vm.prank(bob);
        vm.deal(bob, 5 ether);
        market.addNFT{value: 5 ether}("chanson");
        market.removeNFT("chanson", bob);
        uint256 resultBalance = bob.balance;

        assertEq(
            resultBalance,
            0 ether,
            "Balance should be 0 ether because no refound"
        );
        assertEq(
            market.getUserNFTs(bob).length,
            0,
            "The list of NFTs that the address should have is 0"
        );
    }

    /**
     * @dev Check if the sender can't remove a NFT that he doesn't have 
     */
    function testRemoveNonExistantNFT() public {
        address bob = address(0x1564646485);
        vm.prank(bob);
        vm.deal(bob, 5 ether);
        vm.expectRevert("NFT not found");
        market.removeNFT("Chanson", bob);

        uint256 resultBalance = bob.balance;

        assertEq(resultBalance, 5 ether, "Balance should be the same");
        assertEq(
            market.getUserNFTs(bob).length,
            0,
            "The list of NFTs that the address should have is 0"
        );
    }
}
