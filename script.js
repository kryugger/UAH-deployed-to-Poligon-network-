const { ethers } = require("hardhat");
const { keccak256, toUtf8Bytes, getAddress } = require("ethers");

async function main() {
  const contractAddress = getAddress("0xe8d15560f5ff9c0039283877c0809aec4a5826ab");
  const yourAddress = getAddress("0x12a3de2375c0330ef3aadf6bb6c02a7d9c8a319c");

  const contract = await ethers.getContractAt("UAHToken", contractAddress);

  const DEFAULT_ADMIN_ROLE = "0x0000000000000000000000000000000000000000000000000000000000000000";
  const MINTER_ROLE = keccak256(toUtf8Bytes("MINTER_ROLE"));
  const SNAPSHOT_ROLE = keccak256(toUtf8Bytes("SNAPSHOT_ROLE"));

  const isAdmin = await contract.hasRole(DEFAULT_ADMIN_ROLE, yourAddress);
  const isMinter = await contract.hasRole(MINTER_ROLE, yourAddress);
  const isSnapshot = await contract.hasRole(SNAPSHOT_ROLE, yourAddress);
  const feeWallet = await contract.feeWallet();
  const paused = await contract.paused();

  console.log("✅ Результаты проверки:");
  console.log("Админ:", isAdmin);
  console.log("Минтер:", isMinter);
  console.log("Снапшот:", isSnapshot);
  console.log("feeWallet:", feeWallet);
  console.log("paused:", paused);
}

main().catch((error) => {
  console.error("❌ Ошибка:", error);
  process.exit(1);
});