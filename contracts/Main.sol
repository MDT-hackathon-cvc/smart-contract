// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./common/Upgradeable.sol";
import "./utils/TransferNFT.sol";
import "./utils/TransferToken.sol";
import "./interfaces/IERC165.sol";
import "./interfaces/IERC721.sol";
import "./interfaces/IERC1155.sol";

import "./libs/ERC165Checker.sol";
import "./common/Events.sol";

contract NFTMarketplace is Upgradeable {
    // Library for checking which type of the given collection's address is.
    using ERC165Checker for address;

    function mint(
        address collection,
        uint256 id,
        uint256 amount,
        string calldata uri
    ) external {
        require(defaultCollections[collection], "ONLY DEFAULT COLLECTIONS");

        if (collection.isERC721Compatible()) {
            require(amount == 1, "ONLY_ONE_ERC721");
            IERC721(collection).safeMint(msg.sender, uri);
        } else if (collection.isERC1155Compatible()) {
            IERC1155(collection).mint(msg.sender, id, amount, uri, "");
        } else revert("INVALID ADDRESS");

        emit Minted(collection, id, amount);
    }

    /**
        @dev
        @param collection Collection's address of the NFT
        @param tokenId  The NFT's id
        @param amount   The amount of NFT to put on sale
        @param paymentToken The payment token
        @param price    The price without decimals
     */
    function createOrder(
        address collection,
        uint256 tokenId,
        uint256 amount,
        address paymentToken,
        uint256 price
    ) external {
        Order memory order = Order({
            seller: msg.sender,
            paymentToken: paymentToken,
            collection: collection,
            tokenId: tokenId,
            amount: amount,
            price: price,
            createdAt: block.timestamp
        });

        bytes32 orderId = _createOrder(order);

        // Transfer NFT to this smart contract
        if (order.collection.isERC721Compatible()) {
            require(order.amount == 1, "ONLY_ONE_ERC721");
            IERC721(order.collection).safeTransferFrom(
                order.seller,
                address(this),
                order.tokenId
            );
        } else if (order.collection.isERC1155Compatible()) {
            IERC1155(order.collection).safeTransferFrom(
                order.seller,
                address(this),
                order.tokenId,
                order.amount,
                ""
            );
        } else revert("INVALID_ADDRESS");

        emit OrderCreated(orderId);
    }

    function _createOrder(Order memory order) internal returns (bytes32 id) {
        id = hash(order);
        orders[id] = order;
    }

    // function cancelOrder(bytes32 id) external {
    //     Order memory order = orders[id];

    //     delete orders[id];

    //     // Transfer NFT back to seller.
    //     if (order.collection.isERC721Compatible()) {
    //         IERC721(order.collection).safeTransfer(order.seller, order.tokenId);
    //     } else if (order.collection.isERC1155Compatible()) {
    //         IERC1155(order.collection).safeTransferFrom(
    //             order.seller,
    //             address(this),
    //             order.tokenId,
    //             order.amount,
    //             ""
    //         );
    //     }
    // }
}
