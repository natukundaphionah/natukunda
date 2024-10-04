const { expect } = require("chai");

describe("Arbitrage", function () {
    let arbitrageContract;

    beforeEach(async function () {
        const Arbitrage = await ethers.getContractFactory("Arbitrage");
        arbitrageContract = await Arbitrage.deploy();
        await arbitrageContract.deployed();
    });

    it("should perform arbitrage correctly", async function () {
        // Your test logic here...
        expect(await arbitrageContract.someFunction()).to.equal(expectedValue);
    });
});
