const { ethers } = require("hardhat");

async function main() {
  console.log("🚀 Начинаем деплой всех контрактов...");

  // --------------------
  // 1. Деплой UAH Token
  // --------------------
  const UAH = await ethers.getContractFactory("UAHToken");
  const initialSupply = ethers.parseUnits("24081991", 18); // 24 081 991 токенов

  const uahToken = await UAH.deploy("UAH Token", "UAH", initialSupply);
  await uahToken.waitForDeployment();
  console.log("✅ UAH Token deployed to:", await uahToken.getAddress());

  // --------------------
  // 2. Деплой DAO
  // --------------------
  const DAO = await ethers.getContractFactory("DAO");
  const dao = await DAO.deploy(await uahToken.getAddress());
  await dao.waitForDeployment();
  console.log("✅ DAO deployed to:", await dao.getAddress());

  // --------------------
  // 3. Деплой Governance
  // --------------------
  const Governance = await ethers.getContractFactory("Governance");
  const governance = await Governance.deploy(await dao.getAddress());
  await governance.waitForDeployment();
  console.log("✅ Governance deployed to:", await governance.getAddress());

  // --------------------
  // 4. Деплой Treasury
  // --------------------
  const Treasury = await ethers.getContractFactory("Treasury");
  const treasury = await Treasury.deploy(await uahToken.getAddress(), await dao.getAddress());
  await treasury.waitForDeployment();
  console.log("✅ Treasury deployed to:", await treasury.getAddress());

  // --------------------
  // 5. Деплой DonorBadge
  // --------------------
  const DonorBadge = await ethers.getContractFactory("DonorBadge");
  const donorBadge = await DonorBadge.deploy();
  await donorBadge.waitForDeployment();
  console.log("✅ DonorBadge deployed to:", await donorBadge.getAddress());

  // --------------------
  // 6. Деплой CampaignFactory
  // --------------------
  const CampaignFactory = await ethers.getContractFactory("CampaignFactory");
  const campaignFactory = await CampaignFactory.deploy(await uahToken.getAddress());
  await campaignFactory.waitForDeployment();
  console.log("✅ CampaignFactory deployed to:", await campaignFactory.getAddress());

  // --------------------
  // 7. Деплой CrossChainBridge
  // --------------------
  const CrossChainBridge = await ethers.getContractFactory("Cross_chain_bridge");
  const bridge = await CrossChainBridge.deploy(await uahToken.getAddress());
  await bridge.waitForDeployment();
  console.log("✅ CrossChainBridge deployed to:", await bridge.getAddress());

  console.log("🎉 Все контракты успешно задеплоены!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Ошибка при деплое:", error);
    process.exit(1);
  });