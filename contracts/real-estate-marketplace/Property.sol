// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Property is ERC721Enumerable, Ownable {
    struct PropertyDetails {
        uint256 propertyId;
        string propertyName;
        string location;
        uint256 value;
        bool isBasket;
        uint256[] basketProperties; // Array of property IDs if this is a basket
    }

    mapping(uint256 => PropertyDetails) public properties;

    constructor() ERC721("RealEstateProperty", "PROP") {}

    function createProperty(
        string memory name,
        string memory location,
        uint256 value,
        bool isBasket,
        uint256[] memory basketProperties
    ) external onlyOwner returns (uint256) {
        uint256 propertyId = totalSupply() + 1;
        _mint(msg.sender, propertyId);

        properties[propertyId] = PropertyDetails({
            propertyId: propertyId,
            propertyName: name,
            location: location,
            value: value,
            isBasket: isBasket,
            basketProperties: basketProperties
        });

        return propertyId;
    }

    function getPropertyDetails(uint256 propertyId)
        external
        view
        returns (PropertyDetails memory)
    {
        return properties[propertyId];
    }

    // Define events
    event PropertyUpdated(
        uint256 indexed propertyId,
        address indexed owner,
        string newDescription,
        uint256 newPrice
    );
    event OwnershipTransferred(
        uint256 indexed propertyId,
        address indexed previousOwner,
        address indexed newOwner
    );

    // Define state variables
    struct PropertyDetails {
        address owner;
        string description;
        uint256 price;
        bool isForSale;
        address paymentToken;
    }

    mapping(uint256 => PropertyDetails) public properties;
    uint256 public nextPropertyId;

    // Constructor
    constructor() {}

    // Function to create a new property
    function createProperty(
        string calldata description,
        uint256 price,
        address paymentToken
    ) external whenNotPaused onlyOwner {
        require(price > 0, "Price must be greater than 0");
        require(paymentToken != address(0), "Invalid payment token address");

        properties[nextPropertyId] = PropertyDetails({
            owner: msg.sender,
            description: description,
            price: price,
            isForSale: false,
            paymentToken: paymentToken
        });

        emit PropertyUpdated(nextPropertyId, msg.sender, description, price);
        nextPropertyId++;
    }

    // Function to update property details
    function updateProperty(
        uint256 propertyId,
        string calldata newDescription,
        uint256 newPrice
    ) external whenNotPaused {
        PropertyDetails storage property = properties[propertyId];
        require(
            property.owner == msg.sender,
            "Only the owner can update property details"
        );
        require(newPrice > 0, "Price must be greater than 0");

        property.description = newDescription;
        property.price = newPrice;

        emit PropertyUpdated(propertyId, msg.sender, newDescription, newPrice);
    }

    // Function to set property for sale
    function setPropertyForSale(uint256 propertyId, bool forSale)
        external
        whenNotPaused
    {
        PropertyDetails storage property = properties[propertyId];
        require(
            property.owner == msg.sender,
            "Only the owner can set property for sale"
        );

        property.isForSale = forSale;
    }

    // Function to transfer ownership of the property
    function transferOwnership(uint256 propertyId, address newOwner)
        external
        whenNotPaused
    {
        PropertyDetails storage property = properties[propertyId];
        require(
            property.owner == msg.sender,
            "Only the owner can transfer ownership"
        );
        require(newOwner != address(0), "Invalid new owner address");

        property.owner = newOwner;
        property.isForSale = false; // Automatically remove from sale

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

    // Placeholder for external integration (e.g., with external systems or protocols)
    //function integrateWithExternalSystem(uint256 propertyId) external view returns (bool) {
    // Example integration logic
    //  return true;
    // }
}
