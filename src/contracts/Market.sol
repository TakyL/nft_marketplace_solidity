// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Offer} from "./struct/Offer.sol";
import {NFTContract} from "./Nft.sol";
contract MarketPlace{
    
    address private owner; //The owner of the contract
    
    mapping(address => uint256[]) public userNFTs;
    NFTContract public NFT;//The nft that will be added

    uint public constant FEE = 5 ether; // 0.05 POL
    uint256 public constant REFUND_AMOUNT = 2 ; // 0.025 POL
    
    event NFTAdded(address indexed user, uint256 nftId);
    event NFTRemoved(address indexed user, string  nftId);
    event FEEPayed(address indexed user,uint remaingBalance);
    
    constructor(NFTContract nft)
    {
        NFT = nft;
        owner = address(owner);
    }


    modifier requiresFee() {
        require(msg.value >= FEE, "Insufficient funds to cover the fee");
        _;
    }

    modifier OwnNFT()
    {
                require(getUserNFTs(msg.sender).length==0,"This address doesn't contains any registered nft");
_;
    }

    //Check if the sender has the nft 
    modifier requiresOwner(string memory nftId) 
    {

        _;
    }

    /**
     * Pay a fee for adding a nft to the list 
     * @param nftSongTitle : Hashed title song nft
     */
    function addNFT(string memory nftSongTitle) external payable requiresFee() {

        NFT.mint(msg.sender,nftSongTitle);

        uint256 excess = msg.value - FEE;
        uint256 id= NFT.getTokenId(nftSongTitle);//FIXME should be the nft.id 
        userNFTs[msg.sender].push(id);

        require(userNFTs[msg.sender].length !=0,"push not work wtf");

        if (excess > 0) {
            payable(msg.sender).transfer(excess);
            emit FEEPayed(msg.sender,excess);
        }
        emit NFTAdded(msg.sender,id);       
    }



    /**
     * Remove 
     * @param nftId : Hashed title of the nft
     */
    function removeNFT(string memory nftId,address senderAdd) external OwnNFT  {
        uint256[] storage nfts = userNFTs[senderAdd];
        
        bool found = false;
        
    for (uint256 i = 0; i < nfts.length; i++) {
        if (nfts[i] == NFT.getTokenId(nftId)) {
            // Swap with last element to maintain array integrity
            nfts[i] = nfts[nfts.length - 1]; 
            nfts.pop(); // Remove last element
            found = true;
            break;
        }
    }
        
        require(found, "NFT not found");
        emit NFTRemoved(msg.sender, nftId);
    }
    
    function getMyNFTs() external view returns (uint256[] memory) {
        return userNFTs[msg.sender];
    }

        // Retrieve user's NFTs
    function getUserNFTs(address user) public view returns (uint256[] memory) {
        return userNFTs[user];
    }
    
    receive() external payable {}

    
}
