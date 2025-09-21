# Создание структуры проекта
$projectName = "UAH_token"
New-Item -ItemType Directory -Path $projectName
Set-Location $projectName

# Инициализация npm
npm init -y

# Установка Hardhat и toolbox
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox dotenv

# Создание папок
New-Item -ItemType Directory -Path "contracts"
New-Item -ItemType Directory -Path "scripts"

# Создание контракта UAHtoken.sol
@"
    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.21;

    import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

    contract UAHtoken is ERC20 {
        constructor() ERC20("UAH Token", "UAH") {
            _mint(msg.sender, 1000000 * 10 ** decimals());
        }
    }
"@ | Out-File -Encoding UTF8 "contracts\UAHtoken.sol"

# Создание скрипта деплоя
@"
    const { ethers } = require("hardhat");

    async function main() {
        const Token = await ethers.getContractFactory("UAHtoken");
        const token = await Token.deploy();
        await token.deployed();
        console.log("UAHtoken deployed to:", token.address);
    }

    main().catch((error) => {
        console.error(error);
        process.exitCode = 1;
    });
"@ | Out-File -Encoding UTF8 "scripts\deploy.js"

# Создание hardhat.config.js
@"
    require("@nomicfoundation/hardhat-toolbox");
    require("dotenv").config();

    module.exports = {
        solidity: {
            version: "0.8.21",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200
                }
            }
        },
        networks: {
            polygon: {
                url: process.env.POLYGON_RPC,
                accounts: [`0x${process.env.PRIVATE_KEY}`]
            }
        }
    };
"@ | Out-File -Encoding UTF8 "hardhat.config.js"

# Создание README.md
@"
# UAH Token

UAH — цифровой токен, отражающий украинскую гривну в сети Polygon.

## Контракт

- Название: UAH Token
- Символ: UAH
- Децималы: 18
- Суммарная эмиссия: 1,000,000 UAH

## Деплой

\`\`\`bash
npx hardhat run scripts/deploy.js --network polygon
\`\`\`

## Верификация

\`\`\`bash
npx hardhat verify --network polygon <contract_address>
\`\`\`
"@ | Out-File -Encoding UTF8 "README.md"

Write-Host "✅ Проект $projectName создан. Осталось добавить .env вручную."