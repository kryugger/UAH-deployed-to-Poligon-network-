const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("👤 Аккаунт:", deployer.address);

  const DAO = await hre.ethers.getContract("DAO");
  const Token = await hre.ethers.getContract("UAHToken");

  // Минтим токены и делегируем голос
  const mintTx = await Token.mint(deployer.address, hre.ethers.parseEther("100"));
  await mintTx.wait();
  await Token.delegate(deployer.address);

  // Создаём предложение
  const targets = [deployer.address];
  const values = [0];
  const calldatas = ["0x"];
  const description = "📜 Предложение: ничего не делать";

  const proposeTx = await DAO.propose(targets, values, calldatas, description);
  const receipt = await proposeTx.wait();
  const proposalId = receipt.logs[0].args.proposalId;

  console.log("✅ Предложение создано:", proposalId.toString());

  // Голосуем "за"
  const voteTx = await DAO.castVote(proposalId, 1);
  await voteTx.wait();
  console.log("🗳️ Голос отправлен");

  // Проверяем статус
  const state = await DAO.state(proposalId);
  console.log("📊 Статус предложения:", state);
}

main().catch((error) => {
  console.error("❌ Ошибка:", error);
  process.exitCode = 1;
});