// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Offer} from "./struct/Offer.sol";
import {NFTContract} from "./Nft.sol";

contract MarketPlace {
    address private owner; //The owner of the contract

    mapping(address => uint256[]) public userNFTs; //The list of all users and their owns NFT's
    NFTContract public NFT; //The nft that will be added

    uint public constant FEE = 5 ether; // 0.0

    event NFTAdded(address indexed user, uint256 nftId);
    event NFTRemoved(address indexed user, string nftId);
    event FEEPayed(address indexed user, uint remaingBalance);

    constructor(NFTContract nft) {
        NFT = nft;
        owner = address(this);
    }

    /**
     * @dev Check if the sender has sent at least the excepted fee
     */
    modifier requiresFee() {
        require(msg.value >= FEE, "Insufficient funds to cover the fee");
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
        uint256 excess = msg.value - FEE;
        if (excess > 0) {
            payable(msg.sender).transfer(excess);
            emit FEEPayed(msg.sender, excess);
        }
            //Mint and add the nft
        NFT.mintTo(msg.sender, nftSongTitle);

        uint256 id = NFT.getTokenId(nftSongTitle);
        userNFTs[msg.sender].push(id);

        require(userNFTs[msg.sender].length != 0, "Error when pushing the NFT");

        emit NFTAdded(msg.sender, id);
    }

    /**
     * @dev Remove the nft 
     * @param nftId : Hashed title of the nft
     */
    function removeNFT(string memory nftId) external OwnNFT {
        uint256[] storage nfts = userNFTs[msg.sender];

        bool found = false;

        for (uint256 i = 0; i < nfts.length; i++) {
            if (nfts[i] == NFT.getTokenId(nftId)) {
                nfts[i] = nfts[nfts.length - 1];
                nfts.pop(); // Remove 
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
    function getMyNFTs() external view returns (uint256[] memory) {
        return userNFTs[msg.sender];
    }


    receive() external payable {}
}
