// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IShares {
    // Enum to represent the state of shares issuance
    enum ShareStatus { Issued, Transferred, Redeemed, Cancelled }


    struct ShareBasket {
        uint256 basketId;
        uint256[] propertyIds;
        uint256 totalShares;
    }

    function getBasketDetails(uint256 basketId) external view returns (ShareBasket memory);
    function issueShares(uint256 basketId, address to, uint256 amount) external;
    // Structure to define a shareholding

    struct Shareholding {
        uint256 shareId;
        address holder;
        uint256 propertyId;
        uint256 amount;
        ShareStatus status;
        uint256 issuedAt;
        uint256 lastUpdated;
    }

    // Events
    event SharesIssued(uint256 indexed shareId, address indexed holder, uint256 indexed propertyId, uint256 amount);
    event SharesTransferred(uint256 indexed shareId, address indexed from, address indexed to, uint256 amount);
    event SharesRedeemed(uint256 indexed shareId, address indexed holder, uint256 amount);
    event SharesCancelled(uint256 indexed shareId, address indexed holder, uint256 amount);

    // Function to issue shares for a property
    function issueShares(address holder, uint256 propertyId, uint256 amount) external returns (uint256);

    // Function to transfer shares from one holder to another
    function transferShares(uint256 shareId, address to, uint256 amount) external;

    // Function to redeem shares for a property
    function redeemShares(uint256 shareId, uint256 amount) external;

    // Function to cancel issued shares
    function cancelShares(uint256 shareId, uint256 amount) external;

    // Function to get details of a specific shareholding
    function getShareholding(uint256 shareId) external view returns (Shareholding memory);

    // Function to get the total number of shares issued for a specific property
    function getTotalShares(uint256 propertyId) external view returns (uint256);

    // Function to get the number of shares held by a specific holder
    function getHolderShares(address holder) external view returns (Shareholding[] memory);
}
