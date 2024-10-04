// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// Interface for the Uniswap V2 Router
interface IUniswapV2Router {
    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function WETH() external pure returns (address); // Add WETH() declaration
}

contract TokenBuyer {
    address public owner;
    IUniswapV2Router public uniswapRouter;
    address public token;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(address _uniswapRouter, address _token) {
        owner = msg.sender;
        uniswapRouter = IUniswapV2Router(_uniswapRouter);
        token = _token;
    }

    // Function to buy tokens from the DEX
    function buyToken(uint256 amountOutMin, uint256 deadline) external payable onlyOwner {
        require(msg.value > 0, "Insufficient ETH provided");

        // Initialize path array
        address[] memory path = new address[](2);
        path[0] = uniswapRouter.WETH(); // WETH address (Wrapped ETH)
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
        uint256 tokenBalance = IERC20(token).balanceOf(address(this));
        require(tokenBalance > 0, "No tokens to withdraw");

        require(IERC20(token).transfer(owner, tokenBalance), "Token transfer failed");
    }

    // Function to withdraw any leftover ETH
    function withdrawETH() external onlyOwner {
        uint256 ethBalance = address(this).balance;
        require(ethBalance > 0, "No ETH to withdraw");

        (bool success, ) = owner.call{value: ethBalance}("");
        require(success, "ETH withdrawal failed");
    }

    // Fallback function to receive ETH
    receive() external payable {}
}
