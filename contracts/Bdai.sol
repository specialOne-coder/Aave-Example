//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";


contract Bdai is ERC20 {
    constructor() ERC20("bdai", "bd") {
        _mint(msg.sender, 1000000 * 10**18);
    }
}