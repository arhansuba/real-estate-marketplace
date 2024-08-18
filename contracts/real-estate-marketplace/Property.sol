// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Property is ERC721Enumerable, Ownable, Pausable {
    using SafeERC20 for IERC20;

    // Struct for Property Details
    struct PropertyDetails {
        address owner;
        string description;
        uint256 price;
        bool isForSale;
        address paymentToken;
    }

    // State variables
    mapping(uint256 => PropertyDetails) public properties;
    uint256 public nextPropertyId;

    // Events
    event PropertyCreated(uint256 indexed propertyId, address indexed owner, string description, uint256 price);
    event PropertyUpdated(uint256 indexed propertyId, address indexed owner, string newDescription, uint256 newPrice);
    event OwnershipTransferred(uint256 indexed propertyId, address indexed previousOwner, address indexed newOwner);

    // Constructor
    constructor() ERC721("RealEstateProperty", "PROP")Ownable(msg.sender) Pausable() {}

    // Function to create a new property
    function createProperty(string calldata description, uint256 price, address paymentToken) external whenNotPaused onlyOwner {
        require(price > 0, "Price must be greater than 0");
        require(paymentToken != address(0), "Invalid payment token address");

        uint256 propertyId = nextPropertyId;
        _mint(msg.sender, propertyId);

        properties[propertyId] = PropertyDetails({
            owner: msg.sender,
            description: description,
            price: price,
            isForSale: false,
            paymentToken: paymentToken
        });

        emit PropertyCreated(propertyId, msg.sender, description, price);
        nextPropertyId++;
    }

    // Function to update property details
    function updateProperty(uint256 propertyId, string calldata newDescription, uint256 newPrice) external whenNotPaused {
        PropertyDetails storage property = properties[propertyId];
        require(property.owner == msg.sender, "Only the owner can update property details");
        require(newPrice > 0, "Price must be greater than 0");

        property.description = newDescription;
        property.price = newPrice;

        emit PropertyUpdated(propertyId, msg.sender, newDescription, newPrice);
    }

    // Function to set property for sale
    function setPropertyForSale(uint256 propertyId, bool forSale) external whenNotPaused {
        PropertyDetails storage property = properties[propertyId];
        require(property.owner == msg.sender, "Only the owner can set property for sale");

        property.isForSale = forSale;
    }

    // Function to transfer ownership of the property
    function transferOwnership(uint256 propertyId, address newOwner) external whenNotPaused {
        PropertyDetails storage property = properties[propertyId];
        require(property.owner == msg.sender, "Only the owner can transfer ownership");
        require(newOwner != address(0), "Invalid new owner address");

        property.owner = newOwner;
        property.isForSale = false;  // Automatically remove from sale

        emit OwnershipTransferred(propertyId, msg.sender, newOwner);
    }

    // Function to purchase a property
    function purchaseProperty(uint256 propertyId) external whenNotPaused {
        PropertyDetails storage property = properties[propertyId];
        require(property.isForSale, "Property is not for sale");
        require(property.price > 0, "Property price must be set");

        IERC20 paymentToken = IERC20(property.paymentToken);
        uint256 price = property.price;

        paymentToken.safeTransferFrom(msg.sender, property.owner, price);
        property.owner = msg.sender;
        property.isForSale = false;

        emit OwnershipTransferred(propertyId, property.owner, msg.sender);
    }

    // Function to pause contract functions in emergencies
    function pause() external onlyOwner {
        _pause();
    }

    // Function to unpause contract functions
    function unpause() external onlyOwner {
        _unpause();
    }
}
