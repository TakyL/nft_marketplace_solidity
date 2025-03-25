// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * An offer
 * @param amount : Represent the amount of the offer
 * @param vendoraddress : Vendor's address
 * @param buyeraddress : Buyer's address
 * @param transacttimeoffer : Timestamp of the offer (created or updated)
 * @param id_nft : Id of the nft
 */
struct Offer {
    uint256 amount;
    address vendoraddress;
    //address payable buyeraddress;
    //uint256 transacttimeoffer;
    uint256 id_nft; 
}