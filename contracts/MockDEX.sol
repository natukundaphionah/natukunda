// contracts/MockDEX.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IDEX.sol";

contract MockDEX is IDEX {
    function getAmountsOut(uint256 amountIn, address[] calldata path) external pure override returns (uint256[] memory amounts) {
        amounts = new uint256[](path.length);
        for (uint256 i = 0; i < path.length; i++) {
            amounts[i] = amountIn; // Simplified for testing; in a real DEX, this would depend on market conditions
        }
    }

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external override returns (uint256[] memory amounts) {
        amounts = new uint256[](path.length);
        amounts[0] = amountIn;
        amounts[path.length - 1] = amountIn + 100; // Return a higher amount to simulate profit
    }
}
