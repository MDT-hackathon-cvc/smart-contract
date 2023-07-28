// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./common/Upgradeable.sol";
import "./common/Receiver.sol";
import "./utils/TransferNFT.sol";
import "./utils/TransferToken.sol";
import "./interfaces/IERC165.sol";
import "./interfaces/IERC721.sol";
import "./interfaces/IERC1155.sol";
import "./interfaces/IERC20.sol";

import "./libs/ERC165Checker.sol";
import "./common/Events.sol";

contract NFTMarketplace is Upgradeable, Receiver {
    // Library for checking which type of the given collection's address is.
    using ERC165Checker for address;

    /**
        @dev Execute when the user mints new NFT
        @param collection The collection's address
        @param id The token's id (cid to decimal)
        @param amount The amount to mint
        @param uri The NFT's uri (ipfs link)
     */
    function mint(
        address collection,
        uint256 id,
        uint256 amount,
        string calldata uri
    ) external {
        require(defaultCollections[collection], "ONLY DEFAULT COLLECTIONS");

        if (collection.isERC721Compatible()) {
            require(amount == 1, "ONLY_ONE_ERC721");
            IERC721(collection).safeMint(msg.sender, id, uri);
        } else if (collection.isERC1155Compatible()) {
            IERC1155(collection).mint(msg.sender, id, amount, uri, "");
        } else revert("INVALID ADDRESS");

        emit Minted(collection, id, amount);
    }

    /**
        @dev Execute when the user makes a request to create an order.
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
    ) external returns (bytes32) {
        Order memory order = Order({
            seller: msg.sender,
            paymentToken: paymentToken,
            collection: collection,
            tokenId: tokenId,
            amount: amount,
            price: price,
            createdAt: block.timestamp
        });

        if (order.paymentToken != address(0)) {
            require(
                order.paymentToken.isERC20Compatible(),
                "INVALID_TOKEN_ADDRESS"
            );
        }

        bytes32 orderId = _createOrder(order);

        // Transfer NFT to this smart contract
        _transferNFT(
            order.collection,
            order.seller,
            address(this),
            order.tokenId,
            order.amount
        );

        emit OrderCreated(orderId);

        return orderId;
    }

    function _createOrder(Order memory order) internal returns (bytes32 id) {
        id = hash(order);
        orderInfos[id] = order;
        activeOrders[id] = true;
        orders.push(id);
    }

    function _removeOrder(bytes32 id) internal {
        // Delete from `orderInfos`
        delete orderInfos[id];

        // Deactivate the order
        activeOrders[id] = false;

        // Remove from `orders` array
        bytes32[] memory currentOrders = orders;
        uint256 len = currentOrders.length;

        for (uint256 i = 0; i < len; i++) {
            if (currentOrders[i] == id) {
                currentOrders[i] = currentOrders[len - 1];
                orders = currentOrders;
                orders.pop();
                break;
            }
        }
    }

    /**
        @dev Execute when the seller makes a request to cancel his/her order.
        @param id The order's id to be cancelled
     */
    function cancelOrder(bytes32 id) external {
        Order memory order = orderInfos[id];

        require(activeOrders[id], "INACTIVE_ORDER");
        require(msg.sender == order.seller, "ONLY_SELLER");

        _removeOrder(id);

        // Transfer NFT back to seller.
        _transferNFT(
            order.collection,
            address(this),
            order.seller,
            order.tokenId,
            order.amount
        );

        emit OrderCanceled(id);
    }

    /**
        @dev Execute when the user makes a request to buy a NFT.
        @param orderId The order's id
        @param buyAmount The amount of NFT to buy
     */
    function buy(bytes32 orderId, uint256 buyAmount) external payable {
        Order memory order = orderInfos[orderId];

        require(activeOrders[orderId], "INACTIVE_ORDER");

        uint256 remain = order.amount - buyAmount;
        require(remain >= 0, "Not enough NFT");

        if (remain == 0) {
            _removeOrder(orderId);
        } else {
            order.amount = remain;
        }

        // Handle payment
        // uint256 decimals = IERC20(order.paymentToken).decimals();
        uint256 paymentAmount = buyAmount * order.price;
        uint256 feeAmount = (paymentAmount * fee) / RATIO;

        _transferToken(
            order.paymentToken,
            msg.sender,
            order.seller,
            paymentAmount - feeAmount
        );

        _transferToken(order.paymentToken, msg.sender, recipient, feeAmount);

        // Transfer NFT to buyer.
        _transferNFT(
            order.collection,
            address(this),
            msg.sender,
            order.tokenId,
            buyAmount
        );

        emit Purchased(orderId, msg.sender, paymentAmount);
    }

    function _transferNFT(
        address collection,
        address from,
        address to,
        uint256 id,
        uint256 amount
    ) internal {
        if (collection.isERC721Compatible()) {
            require(amount == 1, "INVALID_NFT_AMOUNT");
            IERC721(collection).safeTransferFrom(from, to, id);
        } else if (collection.isERC1155Compatible()) {
            IERC1155(collection).safeTransferFrom(from, to, id, amount, "");
        } else revert("INVALID_COLLECTION_ADDRESS");
    }

    function _transferToken(
        address token,
        address from,
        address to,
        uint256 amount
    ) internal {
        if (token == address(0)) {
            (bool success, ) = to.call{value: amount}("");
            require(success, "FAIL_TRANSFER_ETH");
        } else {
            IERC20(token).transferFrom(from, to, amount);
        }
    }
}
