// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

import "../structs/Structs.sol";
import "./Events.sol";

abstract contract Upgradeable is
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable,
    OwnableUpgradeable,
    Structs,
    Events
{
    mapping(address => uint256) nonces;
    mapping(bytes32 => Order) orders;
    mapping(bytes32 => bool) activeOrders;
    mapping(address => bool) public defaultCollections;

    function initialize() external initializer {
        __ReentrancyGuard_init_unchained();
        __Ownable_init_unchained();
        __UUPSUpgradeable_init_unchained();
    }

    // Required by OZ
    function _authorizeUpgrade(
        address newImplementation
    ) internal virtual override onlyOwner {}
}
