// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IDEX {
    function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

contract Arbitrage {
    address public owner;
    address public dex1;
    address public dex2;
    address public token1;
    address public token2;
    address public token3;
    address public token4;
    address public token5;

    event Approval(address indexed dex, address indexed token, uint256 amount);
    event SwapExecuted(address indexed dex, address[] path, uint256 amountIn, uint256 amountOut);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(
        address _dex1,
        address _dex2,
        address _token1,
        address _token2,
        address _token3,
        address _token4,
        address _token5
    ) {
        owner = msg.sender;
        dex1 = _dex1;
        dex2 = _dex2;
        token1 = _token1;
        token2 = _token2;
        token3 = _token3;
        token4 = _token4;
        token5 = _token5;
    }

    function approveDEX(address dex, address token, uint256 amount) external onlyOwner {
        require(IERC20(token).approve(dex, amount), "Approval failed");
        emit Approval(dex, token, amount);
    }

    function approveMultipleTokens(
        address dex,
        address[] calldata tokens,
        uint256[] calldata amounts
    ) external onlyOwner {
        require(tokens.length == amounts.length, "Tokens and amounts length mismatch");
        for (uint256 i = 0; i < tokens.length; i++) {
            require(IERC20(tokens[i]).approve(dex, amounts[i]), "Approval failed");
            emit Approval(dex, tokens[i], amounts[i]);
        }
    }

    function checkArbitrage(uint256 amount) internal view returns (bool) {
        // Fetch amounts out for token1 -> token2 -> token3 -> token4 -> token5 on dex1
        address[] memory path = new address[](5);
        path[0] = token1;
        path[1] = token2;
        path[2] = token3;
        path[3] = token4;
        path[4] = token5;
        uint256[] memory amountsOutDex1 = IDEX(dex1).getAmountsOut(amount, path);
        uint256 amountOutDex1 = amountsOutDex1[4];

        // Fetch amounts out for token5 -> token4 -> token3 -> token2 -> token1 on dex2
        address[] memory reversePath = new address[](5);
        reversePath[0] = token5;
        reversePath[1] = token4;
        reversePath[2] = token3;
        reversePath[3] = token2;
        reversePath[4] = token1;
        uint256[] memory amountsOutDex2 = IDEX(dex2).getAmountsOut(amountOutDex1, reversePath);
        uint256 amountOutDex2 = amountsOutDex2[4];

        // Check if the final amount is greater than the initial amount (accounting for fees and slippage)
        return amountOutDex2 > amount;
    }

    function executeArbitrage(uint256 amount) external onlyOwner payable {
        require(checkArbitrage(amount), "No arbitrage opportunity");

        // Swap token1 for token2 -> token3 -> token4 -> token5 on dex1
        IERC20(token1).transferFrom(msg.sender, address(this), amount);
        address[] memory path = new address[](5);
        path[0] = token1;
        path[1] = token2;
        path[2] = token3;
        path[3] = token4;
        path[4] = token5;
        uint256[] memory amounts = IDEX(dex1).swapExactTokensForTokens(amount, 0, path, address(this), block.timestamp);
        emit SwapExecuted(dex1, path, amount, amounts[4]);

        // Swap token5 for token4 -> token3 -> token2 -> token1 on dex2
        uint256 token5Amount = IERC20(token5).balanceOf(address(this));
        address[] memory reversePath = new address[](5);
        reversePath[0] = token5;
        reversePath[1] = token4;
        reversePath[2] = token3;
        reversePath[3] = token2;
        reversePath[4] = token1;
        amounts = IDEX(dex2).swapExactTokensForTokens(token5Amount, 0, reversePath, address(this), block.timestamp);
        emit SwapExecuted(dex2, reversePath, token5Amount, amounts[4]);

        // Transfer profit back to the owner
        uint256 profit = IERC20(token1).balanceOf(address(this));
        IERC20(token1).transfer(owner, profit);
    }

    function withdrawTokens(address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(owner, amount);
    }

    function withdrawETH(uint256 amount) external onlyOwner {
        payable(owner).transfer(amount);
    }

    receive() external payable {}
}

/*
dex1: 0x10ED43C718714eb63d5aA57B78B54704E256024E (PancakeSwap Router)
dex2: 0xCDe540d7eAFE93aC5fE6233Bee57E1270D3E330F (BakerySwap Router)
token1: 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c (Wrapped BNB)
token2: 0xe9e7cea3dedca5984780bafc599bd69add087d56 (BUSD)
token3: 0x55d398326f99059ff775485246999027b3197955 (USDT)
token4: 0x0e09fabb73bd3ade0a17ecc321fd13a19e81ce82 (CAKE)
token5: 0x2170ed0880ac9a755fd29b2688956bd959f933f8 (WETH)


deplo4.1  0xDAF76Bf1095fa02A96A7545b8A5CFe3aE8843132



wbnb 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c

deploy5 FLtrade5tokenArb 0x8BEf278614FB8CE3414564dAE1FAF416A159935C

fttrade6 deploy 0x138deE70C6f484C19a7a01522bB077C60d20CBDB

0x138deE70C6f484C19a7a01522bB077C60d20CBDB


token array ["0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c", "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56", "0x55d398326f99059ff775485246999027b3197955", "0x0e09fabb73bd3ade0a17ecc321fd13a19e81ce82", "0x2170Ed0880ac9A755fd29B2688956BD959F933F8"]

amount array [200000000000000, 100000000000000, 100000000000000, 100000000000000, 100000000000000]
*/