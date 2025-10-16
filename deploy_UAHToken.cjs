const { ethers } = require("hardhat");

async function main() {
  console.log("🚀 Деплой UAHToken...");

  const initialSupply = ethers.parseUnits("24081991", 18); // 24 081 991 токенов
  const UAHToken = await ethers.getContractFactory("UAHToken");
  const uahToken = await UAHToken.deploy("UAH Token", "UAH", initialSupply);

  await uahToken.deploymentTransaction().wait();
  console.log("✅ UAHToken задеплоен по адресу:", uahToken.target);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
