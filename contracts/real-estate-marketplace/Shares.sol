// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Shares is ERC20, Ownable, Pausable {
    using Math for uint256;
    using SafeERC20 for IERC20;

    struct ShareBasket {
        uint256 basketId;
        uint256[] propertyIds;
        uint256 totalShares;
    }

    struct PropertyShares {
        uint256 totalShares;
        uint256 availableShares;
        mapping(address => uint256) shareholders;
    }

    mapping(uint256 => ShareBasket) public baskets;
    mapping(uint256 => uint256) public basketShares;
    mapping(uint256 => PropertyShares) public propertyShares;
    mapping(uint256 => address) public propertyOwners;

    event SharesIssued(address indexed investor, uint256 propertyId, uint256 sharesIssued);
    event SharesTransferred(address indexed from, address indexed to, uint256 propertyId, uint256 sharesTransferred);

    constructor() ERC20("PropertyShare", "SHARE") Ownable(msg.sender) {
    }

    function createBasket(uint256 basketId, uint256[] memory propertyIds, uint256 totalShares) external onlyOwner {
        baskets[basketId] = ShareBasket({
            basketId: basketId,
            propertyIds: propertyIds,
            totalShares: totalShares
        });
        basketShares[basketId] = totalShares;
    }

    function issueShares(uint256 basketId, address to, uint256 amount) external onlyOwner {
        require(basketShares[basketId] >= amount, "Insufficient shares available");
        _mint(to, amount);
        basketShares[basketId] -= amount;
    }

    function getBasketDetails(uint256 basketId) external view returns (ShareBasket memory) {
        return baskets[basketId];
    }

    function issuePropertyShares(uint256 propertyId, address investor, uint256 shares) external onlyOwner whenNotPaused {
        require(shares > 0, "Shares must be greater than 0");
        require(propertyShares[propertyId].availableShares >= shares, "Not enough shares available");
        
        PropertyShares storage sharesData = propertyShares[propertyId];
        sharesData.totalShares += shares;
        sharesData.availableShares -= shares;
        sharesData.shareholders[investor] += shares;

        emit SharesIssued(investor, propertyId, shares);
    }

    function transferShares(uint256 propertyId, address to, uint256 shares) external whenNotPaused {
        require(to != address(0), "Invalid recipient address");
        require(propertyShares[propertyId].shareholders[msg.sender] >= shares, "Not enough shares to transfer");
        
        PropertyShares storage sharesData = propertyShares[propertyId];
        sharesData.shareholders[msg.sender] -= shares;
        sharesData.shareholders[to] += shares;

        emit SharesTransferred(msg.sender, to, propertyId, shares);
    }

    function getShares(uint256 propertyId, address shareholder) external view returns (uint256) {
        return propertyShares[propertyId].shareholders[shareholder];
    }

    function getTotalShares(uint256 propertyId) external view returns (uint256) {
        return propertyShares[propertyId].totalShares;
    }

    function getAvailableShares(uint256 propertyId) external view returns (uint256) {
        return propertyShares[propertyId].availableShares;
    }

    function setPropertyOwner(uint256 propertyId, address owner) external onlyOwner {
        require(owner != address(0), "Invalid owner address");
        propertyOwners[propertyId] = owner;
    }

    function getPropertyOwner(uint256 propertyId) external view returns (address) {
        return propertyOwners[propertyId];
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function integrateWithExternalSystem(uint256 /* propertyId */) external pure returns (bool) {
        // Example integration logic
        return true;
    }
}