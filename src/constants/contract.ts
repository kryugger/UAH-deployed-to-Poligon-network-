export const DAO_ADDRESS = "0xYourDaoContractAddressHere"; // замените на реальный адрес

export const DAO_ABI = [
  // Минимальный ABI для voterMetadata и MetadataSubmitted
  {
    "inputs": [
      { "internalType": "uint256", "name": "proposalId", "type": "uint256" },
      { "internalType": "address", "name": "account", "type": "address" }
    ],
    "name": "voterMetadata",
    "outputs": [
      { "internalType": "string", "name": "country", "type": "string" },
      { "internalType": "string", "name": "gender", "type": "string" },
      { "internalType": "string", "name": "ageGroup", "type": "string" },
      { "internalType": "string", "name": "ideology", "type": "string" },
      { "internalType": "string", "name": "religion", "type": "string" }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      { "indexed": true, "internalType": "uint256", "name": "proposalId", "type": "uint256" },
      { "indexed": true, "internalType": "address", "name": "voter", "type": "address" },
      { "indexed": false, "internalType": "string", "name": "country", "type": "string" },
      { "indexed": false, "internalType": "string", "name": "gender", "type": "string" },
      { "indexed": false, "internalType": "string", "name": "ageGroup", "type": "string" },
      { "indexed": false, "internalType": "string", "name": "ideology", "type": "string" },
      { "indexed": false, "internalType": "string", "name": "religion", "type": "string" }
    ],
    "name": "MetadataSubmitted",
    "type": "event"
  }
];