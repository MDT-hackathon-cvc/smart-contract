// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

abstract contract Events {
    event OrderCreated(bytes32 orderHash);
    event OrderCanceled(bytes32 orderHash);
    event Buy(bytes32 orderHash, address buyer, uint256 amount);
}
