const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ArbitrageBot", function () {
    let arbitrageBot;
    let owner;
    let token1;
    let token2;

    beforeEach(async function () {
        [owner] = await ethers.getSigners();

        const ArbitrageBot = await ethers.getContractFactory("ArbitrageBot");
        // Replace with real DEX router addresses
        const dex1Router = '0xYourDex1RouterAddress';
        const dex2Router = '0xYourDex2RouterAddress';
        arbitrageBot = await ArbitrageBot.deploy(dex1Router, dex2Router);
        await arbitrageBot.deployed();

        // Mock ERC20 tokens for testing
        const ERC20 = await ethers.getContractFactory("ERC20Token");
        token1 = await ERC20.deploy("Token1", "TK1", ethers.utils.parseEther("1000"));
        token2 = await ERC20.deploy("Token2", "TK2", ethers.utils.parseEther("1000"));
        await token1.deployed();
        await token2.deployed();
    });

    it("Should execute arbitrage successfully", async function () {
        const amount = ethers.utils.parseEther("10");

        // Approve the contract to spend tokens
        await token1.connect(owner).approve(arbitrageBot.address, amount);

        // Execute arbitrage (mocked swap)
        await arbitrageBot.connect(owner).executeArbitrage(token1.address, token2.address, amount);

        // Check the final balance of tokens
        const token1Balance = await token1.balanceOf(arbitrageBot.address);
        expect(token1Balance).to.be.gt(0);
    });
});
