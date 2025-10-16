// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./DonorBadge.sol";

contract Treasury is AccessControl {
    DonorBadge public badge;
    event Funded(address indexed campaign, uint256 amount);

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    constructor(address owner) {
        require(owner != address(0), "Invalid owner");
        badge = new DonorBadge();
        _setupRole(DEFAULT_ADMIN_ROLE, owner);
        _setupRole(MANAGER_ROLE, owner);
    }

    function fundCampaign(IERC20 token, address campaign, uint256 amount) external onlyRole(MANAGER_ROLE) {
        require(address(token) != address(0), "Invalid token");
        require(campaign != address(0), "Invalid campaign");
        require(amount > 0, "Amount must be > 0");

        token.transfer(campaign, amount);
        badge.mint(msg.sender);
        emit Funded(campaign, amount);
    }
}
