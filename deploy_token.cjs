require("dotenv").config();
const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying from:", deployer.address);

  const UAHToken = await hre.ethers.getContractFactory("UAHToken");
  const token = await UAHToken.deploy();
  await token.initialize(
    deployer.address,
    hre.ethers.utils.parseUnits("24081991", 18),
    deployer.address
  );
  await token.deployed();

  console.log("UAH Token deployed to:", token.address);
}

main().catch((error) => { console.error(error); process.exitCode = 1; });
