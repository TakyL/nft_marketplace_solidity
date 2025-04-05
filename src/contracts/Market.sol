// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Offer} from "./struct/Offer.sol";
import {NFTContract} from "./Nft.sol";
contract MarketPlace {
    address private owner; //The owner of the contract

    mapping(address => string[]) public userNFTs; //The list of all users and their owns NFT's
    NFTContract public NFT; //The nft that will be added

    //1 pol = 10*18 wei => 0.00000000005 POL = 50 M wei 
    uint public constant FEE = 0.05 gwei; // 0.00000000005 POL 
    uint public constant FEEinWEY = 50000000 wei;//50*10e6 or 0.05 gwei or 0.00000000005 POL //The fee value in wei 


    event NFTAdded(address indexed user, string nftId);
    event NFTRemoved(address indexed user, string nftId);
    event FEERefund(address indexed user, uint remaingBalance);

    constructor(NFTContract nft) {
        NFT = nft;
        owner = address(this);
    }

    /**
     * @dev Check if the sender has sent at least the excepted fee
     */
    modifier requiresFee() {
        require( msg.value >= FEE, "Insufficient funds to cover the fee");
        require(msg.sender.balance >= FEEinWEY,"Insufficient balance");
        _;
    }

    /**
     * @dev Check if the sender has any NFT
     */
    modifier OwnNFT() {
        require(
            this.getMyNFTs().length == 0,
            "This address doesn't contains any registered nft"
        );
        _;
    }

    /**
     * @dev Pay a fee for adding a nft to the list
     * @param nftSongTitle : Hashed title song nft
     */
    function addNFT(string memory nftSongTitle) external payable requiresFee {
            //Pay Logic
        uint256 excess =   msg.value - FEEinWEY;

        if (excess > 0) {
           (bool success, ) = payable(msg.sender).call{value: excess}("");
            require(success, "Transfer failed");
            payable(msg.sender).transfer(excess);//The transfert only happen here but the two lines before are required for the test
            emit FEERefund(msg.sender, excess);
        }
            //Mint and add the nft
        NFT.mintTo(msg.sender, nftSongTitle);

        userNFTs[msg.sender].push(nftSongTitle);

        require(userNFTs[msg.sender].length != 0, "Error when pushing the NFT");

        emit NFTAdded(msg.sender, nftSongTitle);
    }

    /**
     * @dev Remove the nft 
     * @param nftId : Hashed title of the nft
     */
    function removeNFT(string memory nftId) external OwnNFT {
        string[] storage nfts = userNFTs[msg.sender];

        bool found = false;

        for (uint256 i = 0; i < nfts.length; i++) {
            if (keccak256(abi.encodePacked(nfts[i])) == keccak256(abi.encodePacked(nftId))) {
                nfts[i] = nfts[nfts.length - 1];
                nfts.pop();// Remove
                found = true;
                break;
            }
        }

        require(found, "NFT not found");
        emit NFTRemoved(msg.sender, nftId);
    }
    /**
     * @dev Retrieve user's NFTs
     * @return list of hashed id 
     */
    function getMyNFTs() external view returns (string[] memory) {
        return userNFTs[msg.sender];
    }


    receive() external payable {}
}
