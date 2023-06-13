// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165CheckerUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/interfaces/IERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/interfaces/IERC721Upgradeable.sol";

library TransferNFTUtils {
    using ERC165CheckerUpgradeable for address;

    bytes4 private constant ERC1155_INTERFACE = 0xd9b67a26;
    bytes4 private constant ERC721_INTERFACE = 0x80ac58cd;

    function transfer(
        address collection,
        address from,
        address to,
        uint256 id,
        uint256 amount
    ) internal {
        if (collection.supportsInterface(ERC1155_INTERFACE)) {
            require(
                IERC1155Upgradeable(collection).balanceOf(from, id) >= amount,
                "Not enough ERC1155 tokens"
            );

            IERC1155Upgradeable(collection).safeTransferFrom(
                from,
                to,
                id,
                amount,
                ""
            );
        } else if (collection.supportsInterface(ERC721_INTERFACE)) {
            require(
                IERC721Upgradeable(collection).ownerOf(id) == from,
                "Not the owner"
            );

            IERC721Upgradeable(collection).safeTransferFrom(from, to, id, "");
        }
    }
}
