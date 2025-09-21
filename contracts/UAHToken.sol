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
    uint256 public feePercent; // пример: 50 = 0.5%

    constructor(uint256 initialSupply, address owner) ERC20("UAH Token", "UAH") {
        _setupRole(DEFAULT_ADMIN_ROLE, owner);
        _setupRole(SNAPSHOT_ROLE, owner);
        _setupRole(MINTER_ROLE, owner);
        _mint(owner, initialSupply);
        feeWallet = owner;
        feePercent = 0;
    }

    function snapshot() external onlyRole(SNAPSHOT_ROLE) {
        _snapshot();
    }

    function setFee(uint256 _feePercent) external onlyRole(DEFAULT_ADMIN_ROLE) {
        feePercent = _feePercent;
    }

    function setFeeWallet(address _wallet) external onlyRole(DEFAULT_ADMIN_ROLE) {
        feeWallet = _wallet;
    }

    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        if(feePercent > 0 && feeWallet != address(0) && sender != feeWallet) {
            uint256 fee = (amount * feePercent) / 10000; // feePercent в сотых долях процента
            super._transfer(sender, feeWallet, fee);
            amount -= fee;
        }
        super._transfer(sender, recipient, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Snapshot)
    {
        super._beforeTokenTransfer(from, to, amount);
        require(!paused(), "Token transfers are paused");
    }
}
