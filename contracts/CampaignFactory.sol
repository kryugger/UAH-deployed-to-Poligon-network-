// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./Campaign.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CampaignFactory {
    address[] public campaigns;

    /// @notice Создаёт новый кампейн с ERC20 токеном
    /// @param token Адрес ERC20 токена, который будет использоваться для пожертвований
    /// @param beneficiary Получатель средств кампейна
    /// @param target Целевая сумма в токенах
    /// @param deadline Временная метка (timestamp) окончания кампейна
    function createCampaign(
        address token,
        address beneficiary,
        uint256 target,
        uint256 deadline
    ) external {
        require(token != address(0), "Invalid token address");
        require(beneficiary != address(0), "Invalid beneficiary");
        require(deadline > block.timestamp, "Deadline must be in the future");

        // Создаём новый Campaign, передаём IERC20 токен
        Campaign c = new Campaign(IERC20(token), beneficiary, target, deadline);
        campaigns.push(address(c));
    }

    /// @notice Возвращает все созданные кампейны
    function allCampaigns() external view returns (address[] memory) {
        return campaigns;
    }
}
