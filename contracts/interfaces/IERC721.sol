// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/interfaces/IERC721Upgradeable.sol";

interface IERC721 is IERC721Upgradeable {
    function safeMint(
        address to,
        uint256 tokenId,
        string calldata uri
    ) external;
}
