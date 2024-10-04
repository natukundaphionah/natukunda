const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Lock contract", function () {
  let owner, otherAccount;
  let lock;
  let unlockTime; // Define unlockTime here
  const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60; // Define ONE_YEAR_IN_SECS outside

  beforeEach(async function () {
    const Lock = await ethers.getContractFactory("Lock");

    // Get the current block timestamp
    unlockTime = (await ethers.provider.getBlock("latest")).timestamp + ONE_YEAR_IN_SECS;
    const lockedAmount = ethers.utils.parseEther("1");

    [owner, otherAccount] = await ethers.getSigners();
    lock = await Lock.deploy(unlockTime, { value: lockedAmount });
    await lock.deployed();
  });

  it("Should set the right unlockTime", async function () {
    const storedUnlockTime = await lock.unlockTime();
    expect(storedUnlockTime).to.equal(unlockTime);
  });

  it("Should set the right owner", async function () {
    const contractOwner = await lock.owner();
    expect(contractOwner).to.equal(owner.address);
  });

  it("Should receive and store the funds to lock", async function () {
    const contractBalance = await ethers.provider.getBalance(lock.address);
    expect(contractBalance).to.equal(lockedAmount);
  });

  it("Should fail if the unlockTime is not in the future", async function () {
    const Lock = await ethers.getContractFactory("Lock");
    await expect(
      Lock.deploy((await ethers.provider.getBlock("latest")).timestamp - ONE_YEAR_IN_SECS, { value: lockedAmount })
    ).to.be.revertedWith("Unlock time should be in the future");
  });
});
