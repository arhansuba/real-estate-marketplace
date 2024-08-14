// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

interface IAlvaraProtocol {
    function checkPropertyIntegration(uint256 propertyId) external view returns (bool);
}

contract Marketplace is Ownable, Pausable {
    using SafeERC20 for IERC20;

    // Define events
    event PropertyListed(uint256 propertyId, address indexed owner, uint256 price, uint256 totalShares);
    event SharesPurchased(uint256 propertyId, address indexed buyer, uint256 shares);
    event PropertySold(uint256 propertyId, address indexed buyer, uint256 shares);
    
    // Define state variables
    struct Property {
        address owner;
        uint256 price;
        uint256 totalShares;
        uint256 availableShares;
        address tokenAddress; // ERC20 token used for payments
        bool isListed;
    }
    
    mapping(uint256 => Property) public properties;
    uint256 public nextPropertyId;
    
    IERC20 public paymentToken; // Payment token for purchasing shares
    IAlvaraProtocol public alvaraProtocol; // Instance of the Alvara Protocol
    
    // Constructor
    constructor(IERC20 _paymentToken, IAlvaraProtocol _alvaraProtocol) Ownable(msg.sender) {
        paymentToken = _paymentToken;
        alvaraProtocol = _alvaraProtocol;
    }
    
    // Function to list a property
    function listProperty(uint256 price, uint256 totalShares, address tokenAddress) external whenNotPaused {
        require(price > 0, "Price must be greater than 0");
        require(totalShares > 0, "Total shares must be greater than 0");
        
        properties[nextPropertyId] = Property({
            owner: msg.sender,
            price: price,
            totalShares: totalShares,
            availableShares: totalShares,
            tokenAddress: tokenAddress,
            isListed: true
        });
        
        emit PropertyListed(nextPropertyId, msg.sender, price, totalShares);
        nextPropertyId++;
    }
    
    // Function to purchase shares in a property
    function purchaseShares(uint256 propertyId, uint256 sharesToBuy) external whenNotPaused {
        Property storage property = properties[propertyId];
        require(property.isListed, "Property is not listed");
        require(property.availableShares >= sharesToBuy, "Not enough shares available");
        require(sharesToBuy > 0, "Shares to buy must be greater than 0");
        
        uint256 totalPrice = (property.price * sharesToBuy) / property.totalShares;
        paymentToken.safeTransferFrom(msg.sender, address(this), totalPrice);
        
        property.availableShares -= sharesToBuy;
        
        emit SharesPurchased(propertyId, msg.sender, sharesToBuy);
    }
    
    // Function to finalize the sale of a property
    function finalizeSale(uint256 propertyId, address buyer) external whenNotPaused {
        Property storage property = properties[propertyId];
        require(property.owner == msg.sender, "Only the owner can finalize the sale");
        require(property.availableShares == 0, "Shares are still available");
        
        property.isListed = false;
        property.owner = buyer;
        
        uint256 totalPayment = property.price;
        paymentToken.safeTransfer(property.owner, totalPayment);
        
        emit PropertySold(propertyId, buyer, property.totalShares);
    }
    
    // Function to pause contract functions in emergencies
    function pause() external onlyOwner {
        _pause();
    }
    
    // Function to unpause contract functions
    function unpause() external onlyOwner {
        _unpause();
    }
    
    // Function to integrate with Alvara Protocol
    function integrateWithAlvara(uint256 propertyId) external view returns (bool) {
        return alvaraProtocol.checkPropertyIntegration(propertyId);
    }
}