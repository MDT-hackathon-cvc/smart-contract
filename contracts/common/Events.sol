// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

abstract contract Events {
    event OrderCreated(bytes32 orderId);
    event OrderCanceled(bytes32 orderId);
    // event Buy(bytes32 orderHash, address buyer, uint256 amount);
    event Minted(address collection, uint256 tokenId, uint256 amount);
}
