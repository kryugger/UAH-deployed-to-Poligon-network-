require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");
require("@typechain/hardhat");

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.21",
        settings: {
          optimizer: {
            enabled: true,
            runs: 50 // можно уменьшить до 10–20 для минимального размера
          }
        }
      }
    ]
  },
  paths: {
    sources: "./contracts",
    artifacts: "./artifacts",
    cache: "./cache"
  },
  typechain: {
    outDir: "typechain-types",
    target: "ethers-v6"
  },
  networks: {
    hardhat: {},
    polygon: {
      url: process.env.POLYGON_RPC_URL || "",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : []
    },
    arbitrum: {
      url: process.env.ARBITRUM_RPC_URL || "",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : []
    },
    bsc: {
      url: process.env.BSC_RPC_URL || "",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : []
    }
  }
};