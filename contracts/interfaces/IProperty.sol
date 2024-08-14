// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IProperty {
    // Enum to represent the state of the property
    enum PropertyStatus { Active, Inactive, Sold, Removed }

    // Structure to define the details of a property
    struct PropertyDetails {
        uint256 id;
        address owner;
        string location;
        string description;
        uint256 price;
        PropertyStatus status;
        uint256 createdAt;
        uint256 updatedAt;
    }

    // Events
    event PropertyCreated(uint256 indexed propertyId, address indexed owner, string location, string description, uint256 price);
    event PropertyUpdated(uint256 indexed propertyId, uint256 newPrice, PropertyStatus newStatus);
    event PropertyOwnershipTransferred(uint256 indexed propertyId, address indexed newOwner, uint256 price);
    event PropertyStatusChanged(uint256 indexed propertyId, PropertyStatus newStatus);
    event PropertyRemoved(uint256 indexed propertyId, address indexed owner);

    // Function to get property details
    function getPropertyDetails(uint256 propertyId) external view returns (PropertyDetails memory);

    // Function to update property details
    function updateProperty(uint256 propertyId, string calldata location, string calldata description, uint256 price) external;

    // Function to transfer ownership of the property
    function transferOwnership(uint256 propertyId, address newOwner) external payable;

    // Function to change the status of the property
    function changePropertyStatus(uint256 propertyId, PropertyStatus newStatus) external;

    // Function to remove the property from the system
    function removeProperty(uint256 propertyId) external;

    // Function to get the total number of properties managed by the contract
    function getTotalProperties() external view returns (uint256);
}
