// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

abstract contract Events {
    event OrderCreated(bytes32 indexed orderId);
    event OrderCanceled(bytes32 indexed orderId);
    event Purchased(bytes32 indexed orderId, address buyer, uint256 amount);
    event Minted(address collection, uint256 tokenId, uint256 amount);
    event RecipientChanged(
        address indexed oldRecipient,
        address indexed newRecipient
    );
}
