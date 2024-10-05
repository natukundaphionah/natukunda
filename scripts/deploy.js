const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const Arbitrage = await ethers.getContractFactory("Arbitrage");
  const arbitrage = await Arbitrage.deploy(
    "0x10ED43C718714eb63d5aA57B78B54704E256024E", // dex1 (PancakeSwap Router)
    "0xCDe540d7eAFE93aC5fE6233Bee57E1270D3E330F", // dex2 (BakerySwap Router)
    "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c", // token1 (Wrapped BNB)
    "0xe9e7cea3dedca5984780bafc599bd69add087d56", // token2 (BUSD)
    "0x55d398326f99059ff775485246999027b3197955", // token3 (USDT)
    "0x0e09fabb73bd3ade0a17ecc321fd13a19e81ce82", // token4 (CAKE)
    "0x2170ed0880ac9a755fd29b2688956bd959f933f8"  // token5 (WETH)
  );

  await arbitrage.deployed();

  console.log("Arbitrage contract deployed to:", arbitrage.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });