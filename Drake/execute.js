const { ethers } = require("hardhat");

async function main() {
    // Get the signers
    const [owner] = await ethers.getSigners();

    // Replace with the actual deployed contract addresses
    const tokenBuyerAddress = "0xE063dF140929bC0423B7e152A935dF8b7F8cfCdF"; // Replace with your deployed TokenBuyer address
    //const tokenAddress = "0xYourTokenAddress"; // Replace with your deployed token address
    //const uniswapRouterAddress = "0xYourUniswapRouterAddress"; // Replace with your deployed Uniswap router address

    // Get the TokenBuyer contract instance
    const TokenBuyer = await ethers.getContractFactory("TokenBuyer");
    const tokenBuyer = TokenBuyer.attach(tokenBuyerAddress);

    // Example: Buy tokens
    const amountOutMin = 0; // Set minimum amount out (depends on your logic)
    const deadline = Math.floor(Date.now() / 1000) + 60 * 20; // 20 minutes from now

    console.log("Buying tokens...");
    const tx = await tokenBuyer.connect(owner).buyToken(amountOutMin, deadline, {
        value: ethers.utils.parseEther("1") // Send 1 ETH for the purchase
    });
    
    await tx.wait(); // Wait for the transaction to be mined
    console.log(`Tokens bought. Transaction hash: ${tx.hash}`);

    // Example: Withdraw tokens
    console.log("Withdrawing tokens...");
    const withdrawTx = await tokenBuyer.connect(owner).withdrawTokens();
    
    await withdrawTx.wait(); // Wait for the transaction to be mined
    console.log(`Tokens withdrawn. Transaction hash: ${withdrawTx.hash}`);

    // Example: Withdraw ETH
    console.log("Withdrawing ETH...");
    const withdrawEthTx = await tokenBuyer.connect(owner).withdrawETH();
    
    await withdrawEthTx.wait(); // Wait for the transaction to be mined
    console.log(`ETH withdrawn. Transaction hash: ${withdrawEthTx.hash}`);
}

// Execute the script
main()
  .then(() => process.exit(0))
  .catch((error) => {
      console.error(error);
      process.exit(1);
  });
