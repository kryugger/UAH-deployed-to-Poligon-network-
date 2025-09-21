// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./Campaign.sol";

contract CampaignFactory {
    address[] public campaigns;

    function createCampaign(address token, address beneficiary, uint256 target, uint256 deadline) external {
        Campaign c = new Campaign(IERC20(token), beneficiary, target, deadline);
        campaigns.push(address(c));
    }

    function allCampaigns() external view returns(address[] memory) {
        return campaigns;
    }
}
