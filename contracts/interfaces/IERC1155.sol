// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/interfaces/IERC1155Upgradeable.sol";

interface IERC1155 is IERC1155Upgradeable {
    function mint(
        address account,
        uint256 id,
        uint256 amount,
        string calldata uri,
        bytes calldata data
    ) external;
}
