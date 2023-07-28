// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract MDT1155 is ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155Supply {
    mapping(uint256 => string) _tokenURIs;
    address minter;

    constructor(address _minter) ERC1155("") {
        minter = _minter;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        string calldata uri,
        bytes memory data
    ) public onlyOwner {
        _mint(account, id, amount, data);
        setTokenURI(id, uri);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) whenNotPaused {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    // The followings were added
    modifier onlyMinter() {
        require(msg.sender == owner() || msg.sender == minter, "ONLY_MINTER");
        _;
    }

    event MinterChanged(address oldMinter, address newMinter);
    event TokenURIUpdated(uint256 tokenId, string oldURI, string newURI);

    function changeMinter(address newMinter) external onlyOwner {
        require(newMinter != address(0), "ZERO_ADDRESS");
        emit MinterChanged(minter, newMinter);
        minter = newMinter;
    }

    function setTokenURI(
        uint256 tokenId,
        string calldata uri
    ) public onlyOwner {
        _tokenURIs[tokenId] = uri;
    }
}
