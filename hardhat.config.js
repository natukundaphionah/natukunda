require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const BSC_TESTNET_API_KEY = process.env.BSC_TESTNET_API_KEY;

module.exports = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      chainId: 1337,
    },
    anvil: {
      url: "http://localhost:8545",
      accounts: [`0x${PRIVATE_KEY}`],
    },
    bscTestnet: {
      url: `https://data-seed-prebsc-1-s1.binance.org:8545`, // Binance Smart Chain Testnet URL
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  mocha: {
    timeout: 20000,
  },
};