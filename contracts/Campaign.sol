// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Campaign is Pausable {
    IERC20 public token;
    address public beneficiary;
    uint256 public target;
    uint256 public deadline;
    bool public goalReached;

    mapping(address => uint256) public contributions;

    constructor(IERC20 _token, address _beneficiary, uint256 _target, uint256 _deadline) {
        token = _token;
        beneficiary = _beneficiary;
        target = _target;
        deadline = _deadline;
    }

    function contribute(uint256 amount) external whenNotPaused {
        require(block.timestamp <= deadline, "Campaign ended");
        token.transferFrom(msg.sender, address(this), amount);
        contributions[msg.sender] += amount;
    }

    function claimFunds() external whenNotPaused {
        require(block.timestamp > deadline, "Campaign ongoing");
        require(!goalReached, "Funds already claimed");

        if(token.balanceOf(address(this)) >= target) {
            token.transfer(beneficiary, token.balanceOf(address(this)));
            goalReached = true;
        }
    }

    function refund() external whenNotPaused {
        require(block.timestamp > deadline, "Campaign ongoing");
        require(!goalReached, "Goal reached");

        uint256 amount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        if(amount > 0) {
            token.transfer(msg.sender, amount);
        }
    }

    function pauseCampaign() external onlyOwner {
        _pause();
    }

    function unpauseCampaign() external onlyOwner {
        _unpause();
    }

    modifier onlyOwner() {
        require(msg.sender == beneficiary, "Not owner");
        _;
    }
}
