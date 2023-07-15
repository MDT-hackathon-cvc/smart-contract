// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165CheckerUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/interfaces/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/interfaces/IERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/interfaces/IERC20Upgradeable.sol";

library ERC165Checker {
    using ERC165CheckerUpgradeable for address;

    function isERC1155Compatible(
        address collection
    ) internal view returns (bool) {
        return
            collection.supportsInterface(type(IERC1155Upgradeable).interfaceId);
    }

    function isERC721Compatible(
        address collection
    ) internal view returns (bool) {
        return
            collection.supportsInterface(type(IERC721Upgradeable).interfaceId);
    }

    function isERC20Compatible(address token) internal view returns (bool) {
        return token.supportsInterface(type(IERC20Upgradeable).interfaceId);
    }
}
