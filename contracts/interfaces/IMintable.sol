// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

interface IMintable {
    function mint(address user,uint256 amount) external;
}