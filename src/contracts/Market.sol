// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Offer} from "./struct/Offer.sol";
import {NFTContract} from "./Nft.sol";

contract MarketPlace {
    

    NFTContract private nftContract; // Declare an instance of NFTContract to manipulate

    //Vendeur XX =>  id nft => Offer info
    mapping(address => mapping(uint256 => Offer)) public list;
   //mapping(address => Offer) public list;
   //List that contains the list off all nft selled by vendor
   mapping(address => uint256[]) private listNftByVendor;

    event OfferCreated(address indexed vendor, uint256 indexed nftId, uint256 amount, uint256 timestamp);

    event OfferUpdated(address indexed vendor, uint256 indexed nftId, uint256 amount, uint256 timestamp);

    //Check if the nft owner is the sender
    modifier check(uint256 id_nft) 
    {
        //FIXME
        require(nftContract.ownerOf(id_nft) == msg.sender, "Not the NFT owner");
        _;
    }

    modifier offer_exists(uint256 id_offer)
    {
        
        _;
    }
    
    function addOffer(uint256 amount, uint256 id_nft) public check(id_nft)
    {
        require(list[msg.sender][id_nft].amount == 0, "Offer already exists");

        // block.timestamp
        list[msg.sender][id_nft] = Offer(amount, msg.sender,id_nft);
        listNftByVendor[msg.sender].push(id_nft);
        emit OfferCreated(msg.sender, id_nft, amount, block.timestamp);
    }


    function modifyOffer(uint256 amount, uint256 id_nft) public check(id_nft)
    {
        //TODO Check the offer exist and owner of the nft is the msg.sender
 
        list[msg.sender][id_nft] = Offer(amount, msg.sender,id_nft);

        emit OfferUpdated(msg.sender, id_nft, amount, block.timestamp);

    }

    function deleteOffer(uint256 id_nft) public check(id_nft)
    {
        //Check offer existe déjà & owner du nft
        delete list[msg.sender][id_nft];
    }

    function acceptOffer() public 
    {
        //Appel de la fonction nft acceptoffer
    }

   // function retrieveOffer(string memory titleSong) public returns (Offer memory)
   // {
   //     uint256 titleHashed = nftContract.getTokenId(titleSong);

   //     return list[]
   // }

    function retrieveFirstOfferFromVendor(address vendor) public view returns(Offer memory)
    {
        require(listNftByVendor[vendor].length > 0, "No offers available from this vendor");
        
        // Get the first hashtitle (first element in the user's offer list)
        uint256 firstHashtitle = listNftByVendor[vendor][0];
        
        // Return the first offer based on the first hashtitle
        return list[vendor][firstHashtitle];
    }

    
    //TODO add tests this week
}
