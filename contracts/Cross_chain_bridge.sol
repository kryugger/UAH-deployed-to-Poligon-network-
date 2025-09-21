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

contract UAHTokenBridge is ERC20, Ownable {

    ILayerZeroEndpoint public lzEndpoint;

    constructor(address _endpoint) ERC20("UAH Token", "UAH") {
        lzEndpoint = ILayerZeroEndpoint(_endpoint);
    }

    function sendToChain(uint16 chainId, bytes calldata destination, uint256 amount) external payable {
        _burn(msg.sender, amount);
        bytes memory payload = abi.encode(msg.sender, amount);
        lzEndpoint.send(chainId, destination, payload, payable(msg.sender), address(0), bytes(""));
    }

    function mintFromBridge(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
