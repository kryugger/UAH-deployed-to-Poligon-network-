const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("🚀 Deploying contracts with:", deployer.address);

  // 1. Deploy ERC20Votes-compatible token
  const Token = await hre.ethers.getContractFactory("UAHToken");
  const token = await Token.deploy();
  await token.waitForDeployment();
  console.log("✅ Token deployed at:", await token.getAddress());

  // 2. Deploy TimelockController
  const minDelay = 3600; // 1 hour
  const proposers = [deployer.address];
  const executors = [deployer.address];

  const Timelock = await hre.ethers.getContractFactory("TimelockController");
  const timelock = await Timelock.deploy(minDelay, proposers, executors);
  await timelock.waitForDeployment();
  console.log("✅ Timelock deployed at:", await timelock.getAddress());

  // 3. Deploy DAO contract
  const DAO = await hre.ethers.getContractFactory("DAO");
  const dao = await DAO.deploy(await token.getAddress(), await timelock.getAddress());
  await dao.waitForDeployment();
  console.log("✅ DAO deployed at:", await dao.getAddress());
}

main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exitCode = 1;
});