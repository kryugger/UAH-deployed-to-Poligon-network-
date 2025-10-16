// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Campaign {
    IERC20 public token;
    address public beneficiary;
    uint256 public target;
    uint256 public deadline;
    uint256 public totalDonated;

    constructor(
        IERC20 _token,
        address _beneficiary,
        uint256 _target,
        uint256 _deadline
    ) {
        require(address(_token) != address(0), "Invalid token");
        require(_beneficiary != address(0), "Invalid beneficiary");
        require(_deadline > block.timestamp, "Deadline must be in the future");

        token = _token;
        beneficiary = _beneficiary;
        target = _target;
        deadline = _deadline;
    }

    function donate(uint256 amount) external {
        require(block.timestamp < deadline, "Campaign ended");
        require(amount > 0, "Amount must be greater than zero");

        token.transferFrom(msg.sender, beneficiary, amount);
        totalDonated += amount;
    }

    function isSuccessful() external view returns (bool) {
        return totalDonated >= target;
    }
}