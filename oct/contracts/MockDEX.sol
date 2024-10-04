// contracts/MockDEX.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IDEX.sol";

contract MockDEX is IDEX {
    function getAmountsOut(uint256 amountIn, address[] calldata path) external pure override returns (uint256[] memory amounts) {
        // Your implementation here...
    }

    function getAmountsIn(uint256 amountOut, address[] calldata path) external pure override returns (uint256[] memory amounts) {
        // Your implementation here...
    }

    // Other function implementations...
}
