// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/interfaces/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";

library TransferTokenUtils {
    using SafeERC20Upgradeable for IERC20Upgradeable;

    function transfer(
        address token,
        address from,
        address to,
        uint256 amount
    ) internal {
        if (token == address(0)) {
            (bool sent, ) = to.call{value: amount}("");
            require(sent, "Failed to transfer Ether");
            return;
        }

        IERC20Upgradeable(token).safeTransferFrom(from, to, amount);
    }
}
