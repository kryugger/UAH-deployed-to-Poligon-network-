// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract UAHToken is ERC20Snapshot, ERC20Burnable, Pausable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");

    address public feeWallet;
    uint256 public feePercent;     // комиссия на перевод (в сотых долях процента)
    uint256 public burnPercent;    // процент сжигания (в сотых долях процента)
    uint256 public licenseFee;     // стоимость лицензии для внешних контрактов

    mapping(address => bool) public licensedContracts;

    constructor(uint256 initialSupply, address owner) ERC20("UAH Token", "UAH") {
        _setupRole(DEFAULT_ADMIN_ROLE, owner);
        _setupRole(SNAPSHOT_ROLE, owner);
        _setupRole(MINTER_ROLE, owner);

        _mint(owner, initialSupply);

        feeWallet = owner;
        feePercent = 50;        // 0.5%
        burnPercent = 10;       // 0.1%
        licenseFee = 0.1 ether; // лицензия для внешних контрактов
    }

    // 📸 Снимок состояния токена
    function snapshot() external onlyRole(SNAPSHOT_ROLE) {
        _snapshot();
    }

    // 💰 Настройка комиссии
    function setFee(uint256 _feePercent) external onlyRole(DEFAULT_ADMIN_ROLE) {
        feePercent = _feePercent;
    }

    function setBurn(uint256 _burnPercent) external onlyRole(DEFAULT_ADMIN_ROLE) {
        burnPercent = _burnPercent;
    }

    function setFeeWallet(address _wallet) external onlyRole(DEFAULT_ADMIN_ROLE) {
        feeWallet = _wallet;
    }

    function setLicenseFee(uint256 _licenseFee) external onlyRole(DEFAULT_ADMIN_ROLE) {
        licenseFee = _licenseFee;
    }

    // 🛑 Пауза/разморозка
    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    // 🔐 Лицензирование внешних контрактов
    function authorizeContract(address contractAddr) external payable {
        require(msg.value >= licenseFee, "License fee required");
        licensedContracts[contractAddr] = true;
        payable(feeWallet).transfer(msg.value);
    }

    // 🧾 Минтинг с проверкой лицензии
    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        require(licensedContracts[msg.sender], "Contract not licensed");
        _mint(to, amount);
    }

    // 💸 Покупка токенов напрямую
    function buyTokens() external payable {
        require(msg.value > 0, "No ETH sent");
        uint256 rate = 1000; // 1 ETH = 1000 UAH
        uint256 tokensToMint = msg.value * rate;
        _mint(msg.sender, tokensToMint);
        payable(feeWallet).transfer(msg.value);
    }

    // 🔥 Комиссия и сжигание при переводе
    function _transfer(address sender, address recipient, uint256 amount) internal override {
        require(!paused(), "Token transfers are paused");

        uint256 fee = (amount * feePercent) / 10000;
        uint256 burnAmount = (amount * burnPercent) / 10000;
        uint256 netAmount = amount - fee - burnAmount;

        super._transfer(sender, feeWallet, fee);
        _burn(sender, burnAmount);
        super._transfer(sender, recipient, netAmount);
    }

    // 🔒 Проверка перед переводом
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Snapshot)
    {
        super._beforeTokenTransfer(from, to, amount);
        require(!paused(), "Token transfers are paused");
    }
}