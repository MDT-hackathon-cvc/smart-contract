// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract OrderStruct {
    // Define CreateOrder struct here
    struct Order {
        address seller;
        address paymentToken;
        address collection;
        uint256 id;
        uint256 amount;
        uint256 price;
        uint256 createdAt;
        uint256 nonce;
    }

    // Hash function for CreateOrder struct.
    function hash(Order memory order) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    order.seller,
                    order.paymentToken,
                    order.collection,
                    order.id,
                    order.amount,
                    order.price,
                    order.createdAt,
                    order.nonce
                )
            );
    }
}
