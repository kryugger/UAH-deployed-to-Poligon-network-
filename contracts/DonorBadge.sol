// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DonorBadge is ERC721, Ownable {
    uint256 public nextId;
    mapping(address => uint256[]) public badges;

    constructor() ERC721("UAH Donor Badge", "UDB") {}

    function mint(address donor) external onlyOwner {
        _safeMint(donor, nextId);
        badges[donor].push(nextId);
        nextId++;
    }

    function getBadges(address donor) external view returns (uint256[] memory) {
        return badges[donor];
    }
}
