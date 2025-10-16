// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ILayerZeroEndpoint {
    function send(
        uint16 _dstChainId,
        bytes calldata _destination,
        bytes calldata _payload,
        address payable _refundAddress,
        address _zroPaymentAddress,
        bytes calldata _adapterParams
    ) external payable;
}

interface IUAHToken {
    function burnFrom(address account, uint256 amount) external;
    function mint(address to, uint256 amount) external;
}

contract UAHTokenBridge is Ownable {

    ILayerZeroEndpoint public lzEndpoint;
    IUAHToken public token;

    constructor(address _endpoint, address _token) {
        lzEndpoint = ILayerZeroEndpoint(_endpoint);
        token = IUAHToken(_token);
    }

    function sendToChain(uint16 chainId, bytes calldata destination, uint256 amount) external payable {
        token.burnFrom(msg.sender, amount); // вызываем burn у основного токена
        bytes memory payload = abi.encode(msg.sender, amount);
        lzEndpoint.send(chainId, destination, payload, payable(msg.sender), address(0), bytes(""));
    }

    function mintFromBridge(address to, uint256 amount) external onlyOwner {
        token.mint(to, amount); // вызываем mint у основного токена
    }
}
