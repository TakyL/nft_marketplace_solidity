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
            //Set address and give money 
        address bob = address(0x1564646485);
        vm.prank(bob);
        vm.deal(bob, 1 gwei);//1 POL = 10^-9 gwei = 1*10^-18 wei

            //Check emit
        vm.expectEmit();
        emit MarketPlace.NFTAdded(bob,"chanson"); 

            //Add bob a nft
        market.addNFT{value: 0.05 gwei }("chanson");
        uint256 resultBalance = bob.balance;

        assertEq(
            resultBalance,
            950000000  ,
            "Balance should be reduced by 0.05gwei so 9500000000 wei so 0.0000000095 POL"
        );
        vm.prank(bob);
        assertEq(
            market.getMyNFTs().length,
            1,
            "The list of NFTs that the address should have is 1"
        );
    }

    /**
     * @dev Check if the sender's can't add a NFT if the sender's send value is incorrect
     */
    function testInsuffiantAmount() public {
        address bob = address(0x1564646485);
        vm.prank(bob);
        vm.deal(bob, 5 gwei);
        vm.expectRevert("Insufficient funds to cover the fee");
        market.addNFT{value: 0.04 gwei}("chanson");
    }
    /**
     * @dev Check if the sender's balanced has been refound if he sent more token than needed
     */
    function testRefundIfExcess() public {
            //Set Address and money
        address bob = address(0x1564646485);
        vm.prank(bob);
        vm.deal(bob, 1 gwei );

            //Check the emit if the refund has been sent (0.3 gwei)
        vm.expectEmit();
        emit MarketPlace.FEERefund(bob,30000000); 
            //Add a NFT to bob
        market.addNFT{value: 0.08 gwei }("chanson");
        uint256 resultBalance = bob.balance;
        assertEq(resultBalance, 980000000, "Balance should be by  0.3 gwei ");
        vm.prank(bob);
        assertEq(
            market.getMyNFTs().length,
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
            //Set Address and money
        address bob = address(0x1564646485);
        vm.prank(bob);
        vm.deal(bob, 1 gwei);
            //Add bob a NFT
        market.addNFT{value: 0.05 gwei}("chanson");
        vm.prank(bob);
            //Check if the emit has been fired
        vm.expectEmit();
        emit MarketPlace.NFTRemoved(bob,"chanson"); 
        market.removeNFT("chanson");

        uint256 resultBalance = bob.balance;

        assertEq(
            resultBalance,
            950000000,
            "Balance should be 0.95 gwei because no refound"
        );
        assertEq(
            market.getMyNFTs().length,
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
        vm.deal(bob, 5 gwei);
        vm.expectRevert("NFT not found");
        market.removeNFT("Chanson");

        uint256 resultBalance = bob.balance;

        assertEq(resultBalance, 5000000000, "Balance should be the same, so 5 gwei");
        vm.prank(bob);
        assertEq(
            market.getMyNFTs().length,
            0,
            "The list of NFTs that the address should have is 0"
        );
    }
}
