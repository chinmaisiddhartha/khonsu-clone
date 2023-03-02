// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


interface IPriceFeed {
    function getRate(IERC20 srcToken, IERC20 dstToken, bool useWrappers) external view returns (uint256 weightedRate);
}