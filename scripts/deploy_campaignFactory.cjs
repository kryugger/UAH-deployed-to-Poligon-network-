const hre = require("hardhat");
require('dotenv').config();

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying CampaignFactory with account:", deployer.address);

  const CampaignFactory = await hre.ethers.getContractFactory("CampaignFactory");
  const factory = await CampaignFactory.deploy();

  await factory.deployed();
  console.log("CampaignFactory deployed at:", factory.address);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
