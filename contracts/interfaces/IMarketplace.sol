// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMarketplace {
    // Enum to represent the current state of the property listing
    enum ListingStatus { Active, Inactive, Sold, Removed }

    // Structure for property details
    struct PropertyDetails {
        uint256 id;
        address owner;
        string location;
        string description;
        uint256 price;
        ListingStatus status;
        uint256 createdAt;
        uint256 updatedAt;
    }

    // Structure for property share details
    struct ShareDetails {
        uint256 propertyId;
        address owner;
        uint256 sharesOwned;
    }

    // Events
    event PropertyListed(uint256 indexed propertyId, address indexed owner, uint256 price);
    event PropertyUpdated(uint256 indexed propertyId, uint256 price, ListingStatus status);
    event PropertySold(uint256 indexed propertyId, address indexed newOwner, uint256 price);
    event SharesIssued(uint256 indexed propertyId, address indexed shareholder, uint256 sharesAmount);
    event SharesTransferred(uint256 indexed propertyId, address indexed from, address indexed to, uint256 sharesAmount);
    event PropertyRemoved(uint256 indexed propertyId, address indexed owner);

    // Function to list a new property
    function listProperty(string calldata location, string calldata description, uint256 price) external returns (uint256);

    // Function to update property details
    function updateProperty(uint256 propertyId, uint256 newPrice, ListingStatus newStatus) external;

    // Function to buy a property
    function buyProperty(uint256 propertyId) external payable;

    // Function to remove a property listing
    function removeProperty(uint256 propertyId) external;

    // Function to issue shares for a property
    function issueShares(uint256 propertyId, address shareholder, uint256 sharesAmount) external;

    // Function to transfer shares between shareholders
    function transferShares(uint256 propertyId, address to, uint256 sharesAmount) external;

    // Function to get details of a property
    function getPropertyDetails(uint256 propertyId) external view returns (PropertyDetails memory);

    // Function to get share details of a property
    function getShareDetails(uint256 propertyId, address shareholder) external view returns (ShareDetails memory);

    // Function to get the total number of properties listed
    function getTotalProperties() external view returns (uint256);
}
