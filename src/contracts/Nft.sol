// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from  "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Nft is ERC721 {
    constructor(uint256 initialSupply) ERC721("Gold", "GLD") {
        _mint(msg.sender, initialSupply);
    }
}