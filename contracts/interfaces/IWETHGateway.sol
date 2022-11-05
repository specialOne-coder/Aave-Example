
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IWETHGateway {

    function depositETH(
        address onBehalfOf,
        uint16 referralCode
    ) external payable;

    function withdrawETH(
        uint256 amount,
        address to
    ) external;
    
}