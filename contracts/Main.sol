// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "./common/Upgradeable.sol";
import "./utils/TransferNFT.sol";
import "./utils/TransferToken.sol";

contract NFTMarketplace is Upgradeable {
    using TransferNFTUtils for address;
    using TransferTokenUtils for address;

    /**
        @param data [0] id, [1] amount, [2] price
        @param addr [0] paymentToken, [1] collection
     */
    function createOrder(
        uint256[] calldata data,
        address[] calldata addr
    ) external {
        Order memory order = Order({
            seller: msg.sender,
            paymentToken: addr[0],
            collection: addr[1],
            id: data[0],
            amount: data[1],
            price: data[2],
            createdAt: block.timestamp,
            nonce: nonces[msg.sender]++
        });

        bytes32 orderHash = hash(order);

        orders[orderHash] = order;

        // Transfer NFT to this smart contract.
        order.collection.transfer(
            msg.sender,
            address(this),
            order.id,
            order.amount
        );

        emit OrderCreated(orderHash);
    }

    function cancelOrder(bytes32 orderHash) external {
        Order memory order = orders[orderHash];
        require(order.seller == msg.sender, "Only order's owner");

        nonces[msg.sender]++;

        order.collection.transfer(
            address(this),
            msg.sender,
            order.id,
            order.amount
        );

        delete orders[orderHash];

        emit OrderCanceled(orderHash);
    }

    function buy(bytes32 orderHash, uint256 buyAmount) external {
        Order memory order = orders[orderHash];

        require(buyAmount <= order.amount, "Not enough NFT");

        order.collection.transfer(
            address(this),
            msg.sender,
            order.id,
            order.amount
        );

        order.amount -= buyAmount;

        if (order.amount == 0) delete orders[orderHash];
        else orders[orderHash] = order;

        // Transfer token to seller.
        order.paymentToken.transfer(
            msg.sender,
            order.seller,
            order.price * buyAmount
        );

        emit Buy(orderHash, msg.sender, buyAmount);
    }
}
