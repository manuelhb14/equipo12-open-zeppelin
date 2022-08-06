// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts@4.7.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.2/security/Pausable.sol";
import "@openzeppelin/contracts@4.7.2/access/AccessControl.sol";
import "@openzeppelin/contracts@4.7.2/utils/Counters.sol";

contract Team12OZBC is ERC721, Pausable, AccessControl {
    using Counters for Counters.Counter;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PRICE_CHANGE_ROLE = keccak256("PRICE_CHANGE_ROLE");

    Counters.Counter private _tokenIdCounter;
    uint256 public _price = 5000000000000000; // 0.005 ETH

    constructor() ERC721("Team12OZBC", "T12OZBC") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(PRICE_CHANGE_ROLE, msg.sender);
    }

    function setPrice(uint256 newPrice) public onlyRole(PRICE_CHANGE_ROLE){
        _price = newPrice;
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address to) public payable onlyRole(MINTER_ROLE) whenNotPaused {
        require(msg.value==_price); //check ether value 
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}