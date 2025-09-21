// deploy_token.cjs

const hre = require("hardhat");
require("dotenv").config();

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("🚀 Deploying UAHToken with account:", deployer.address);

  const UAHToken = await hre.ethers.getContractFactory("UAHToken");

  // Эмиссия токена: 24 081 991 UAH (в честь даты независимости Украины)
  const totalSupply = hre.ethers.parseUnits("24081991", 18);

  // Передаём два аргумента: totalSupply и owner
  const token = await UAHToken.deploy(totalSupply, deployer.address);
  await token.waitForDeployment();

  const tokenAddress = await token.getAddress();
  console.log("✅ UAHToken deployed at:", tokenAddress);
  console.log("👤 Owner address:", deployer.address);

  // Чтение параметров контракта
  const feeWallet = await token.feeWallet();
  const feePercent = await token.feePercent();
  const burnPercent = await token.burnPercent();
  const licenseFee = await token.licenseFee();

  console.log("💰 Fee wallet:", feeWallet);
  console.log("📊 Fee percent:", feePercent.toString(), "basis points");
  console.log("🔥 Burn percent:", burnPercent.toString(), "basis points");
  console.log("📄 License fee:", hre.ethers.formatEther(licenseFee), "BNB");

  // Баланс владельца
  const balance = await token.balanceOf(deployer.address);
  console.log("📦 Initial balance:", hre.ethers.formatUnits(balance, 18), "UAH");

  // Проверка роли MINTER
  const hasMinter = await token.hasRole(await token.MINTER_ROLE(), deployer.address);
  console.log("🔐 MINTER_ROLE assigned:", hasMinter);
}

main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exit(1);
});