require("dotenv").config();
const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("🚀 Deploying governance with:", deployer.address);

  // 1. Загружаем уже задеплоенный токен
  const tokenAddress = process.env.TOKEN_ADDRESS; // UAHToken.sol
  const Token = await ethers.getContractAt("UAHToken", tokenAddress);

  // 2. Деплой Timelock
  const minDelay = 3600; // 1 час (можно менять)
  const proposers = [];
  const executors = [];
  const Timelock = await ethers.getContractFactory("TimelockController");
  const timelock = await Timelock.deploy(minDelay, proposers, executors, deployer.address);
  await timelock.deployed();
  console.log("⏳ Timelock deployed to:", timelock.address);

  // 3. Деплой Governance
  const Governance = await ethers.getContractFactory("Governance");
  const governance = await Governance.deploy(tokenAddress, timelock.address);
  await governance.deployed();
  console.log("🏛 Governance deployed to:", governance.address);

  // 4. Передача MINTER_ROLE DAO
  const MINTER_ROLE = await Token.MINTER_ROLE();
  let tx = await Token.grantRole(MINTER_ROLE, governance.address);
  await tx.wait();
  console.log("✅ MINTER_ROLE передан Governance:", governance.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
