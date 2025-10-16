const hre = require("hardhat");
const { ethers } = hre;
require("dotenv").config();
const fs = require("fs");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("🚀 Deploying from:", deployer.address);

  const totalSupply = ethers.parseUnits("24081991", 18);
  console.log("📤 Deploying UAHToken with args:", [totalSupply, deployer.address]);

  // ✅ Используем безопасный способ — getContractFactory
  const Token = await ethers.getContractFactory("UAHToken");
  const token = await Token.deploy(totalSupply, deployer.address);
  await token.waitForDeployment();

  const tokenAddress = await token.getAddress();
  console.log("✅ UAHToken deployed at:", tokenAddress);

  // Сохраняем адрес
  fs.writeFileSync("UAHToken-address.json", JSON.stringify({ address: tokenAddress }, null, 2));
  fs.appendFileSync(".env", `UAHTOKEN_ADDRESS=${tokenAddress}\n`);

  // Настройка комиссии
  await (await token.setFee(50)).wait(); // 0.5%
  await (await token.setFeeWallet(deployer.address)).wait();

  // Баланс владельца
  const balance = await token.balanceOf(deployer.address);
  console.log("📦 Owner balance:", ethers.formatUnits(balance, 18), "UAH");

  // Верификация контракта на Polygonscan
  try {
    await hre.run("verify:verify", {
      address: tokenAddress,
      constructorArguments: [totalSupply, deployer.address]
    });
    console.log("🔍 Contract verified on Polygonscan");
  } catch (err) {
    console.warn("⚠️ Verification failed:", err.message);
  }
}

main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exit(1);
});