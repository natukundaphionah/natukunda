// contracts/IDEX.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDEX {
    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
    function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
    // Other function declarations...
}
