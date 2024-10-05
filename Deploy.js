async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const TokenBuyer = await ethers.getContractFactory("TokenBuyer");
  const tokenBuyer = await TokenBuyer.deploy(
    "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3",
    "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
  );

  console.log("TokenBuyer contract address:", tokenBuyer.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });