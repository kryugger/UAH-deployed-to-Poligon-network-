const hre = require("hardhat");

async function main() {
  const DonorBadge = await hre.ethers.deployContract("DonorBadge");
  await DonorBadge.waitForDeployment();

  console.log("🎖️ DonorBadge deployed to:", await DonorBadge.getAddress());
}

main().catch((error) => {
  console.error("❌ Ошибка:", error);
  process.exitCode = 1;
});