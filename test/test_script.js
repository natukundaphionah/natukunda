const { expect } = require("chai");
const { ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

// Load the ABI from the JSON file
const tokenBuyerABI = JSON.parse(fs.readFileSync(path.join(__dirname, '../artifacts/contracts/TokenBuyer.sol/TokenBuyer.json'))).abi;

describe("TokenBuyer Contract", function () {
  this.timeout(60000);
  let TokenBuyer, tokenBuyer, owner, addr1;
  let token, uniswapRouter;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();

    // Mock Uniswap Router
    const UniswapRouterMock = await ethers.getContractFactory("UniswapV2RouterMock");
    uniswapRouter = await UniswapRouterMock.deploy();
    await uniswapRouter.deployed();

    // Mock Token
    const TokenMock = await ethers.getContractFactory("ERC20Mock");
    token = await TokenMock.deploy("MockToken", "MTK", ethers.utils.parseEther("1000"));
    await token.deployed();

    // Deploy TokenBuyer contract
    TokenBuyer = await ethers.getContractFactory("TokenBuyer");
    tokenBuyer = await TokenBuyer.deploy(uniswapRouter.address, token.address);
    await tokenBuyer.deployed();
  });

  describe("Deployment", function () {
    it("Should set the correct owner", async function () {
      expect(await tokenBuyer.owner()).to.equal(owner.address);
    });
  });

  describe("Buy and Withdraw Tokens", function () {
    it("Should buy tokens and withdraw them to owner", async function () {
      const initialOwnerBalance = await token.balanceOf(owner.address);

      // Simulate buying tokens
      await tokenBuyer.connect(owner).buyToken(0, Math.floor(Date.now() / 1000) + 60, { value: ethers.utils.parseEther("1") });

      // Check contract balance
      expect(await token.balanceOf(tokenBuyer.address)).to.be.gt(0);

      // Withdraw tokens
      await tokenBuyer.connect(owner).withdrawTokens();

      // Check the owner's token balance
      expect(await token.balanceOf(owner.address)).to.be.gt(initialOwnerBalance);
    });
  });

  describe("Withdraw ETH", function () {
    it("Should withdraw all ETH to the owner", async function () {
      await owner.sendTransaction({ to: tokenBuyer.address, value: ethers.utils.parseEther("1") });

      const initialOwnerEthBalance = await ethers.provider.getBalance(owner.address);

      await tokenBuyer.connect(owner).withdrawETH();

      const finalOwnerEthBalance = await ethers.provider.getBalance(owner.address);
      expect(finalOwnerEthBalance).to.be.gt(initialOwnerEthBalance);
    });
  });
});
