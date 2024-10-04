const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contract with account:", deployer.address);

    // Replace with the router addresses of the DEXs on BSC
    const dex1Router = '0xYourDex1RouterAddress';
    const dex2Router = '0xYourDex2RouterAddress';

    const ArbitrageBot = await ethers.getContractFactory("ArbitrageBot");
    const arbitrageBot = await ArbitrageBot.deploy(dex1Router, dex2Router);

    await arbitrageBot.deployed();
    console.log("ArbitrageBot deployed at:", arbitrageBot.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
