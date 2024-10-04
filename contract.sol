// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Interface for the Uniswap V2 Router
interface IUniswapV2Router {
    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
}

contract TokenBuyer {
    address public owner;
    IUniswapV2Router public uniswapRouter;
    address public token;
       uint public unlockTime;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(address _uniswapRouter, address _token, uint _unlockTime) {
        owner = msg.sender; // Use = for assignment, not ==
        uniswapRouter = IUniswapV2Router(_uniswapRouter);
        token = _token;
        require(_unlockTime > block.timestamp, "Unlock time should be in the future");
        unlockTime = _unlockTime;
        owner = msg.sender;
    }

     

 
    // Function to buy tokens from the DEX
    function buyToken(uint amountOutMin, uint deadline) external payable onlyOwner {
        require(msg.value > 0, "Insufficient ETH provided");

        address[] memory path = new address[](2); // Declare and initialize the path array
        path[0] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH address on mainnet (change for other networks)
        path[1] = token;

        // Perform the swap
        uniswapRouter.swapExactETHForTokens{value: msg.value}(
            amountOutMin,
            path,
            address(this),
            deadline
        );
    }

    // Function to withdraw all tokens to the owner's wallet
    function withdrawTokens() external onlyOwner {
        uint tokenBalance = IERC20(token).balanceOf(address(this));
        require(tokenBalance > 0, "No tokens to withdraw");

        IERC20(token).transfer(owner, tokenBalance);
    }

    // Function to withdraw any leftover ETH
    function withdrawETH() external onlyOwner {
        uint ethBalance = address(this).balance;
        require(ethBalance > 0, "No ETH to withdraw");

        (bool success, ) = owner.call{value: ethBalance}("");
        require(success, "ETH withdrawal failed");
    }

    // Fallback function to receive ETH
    receive() external payable {}
}
