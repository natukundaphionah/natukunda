// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract UniswapV2RouterMock {
    // Mocking the WETH function
    function WETH() external pure returns (address) {
        return 0x0000000000000000000000000000000000000000; // Mock WETH address
    }

    // Mocking the swapExactETHForTokens function
    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts) {
        // Declare the amounts array with two elements
        uint256[] memory amountsOut = new uint256[](2);
        
        amountsOut[0] = msg.value; // Amount of ETH sent
        amountsOut[1] = msg.value; // Mocking token output

        // Simulate the swap
        return amountsOut;
    }
}