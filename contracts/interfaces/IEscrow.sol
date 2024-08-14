// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEscrow {
    // Enum to represent the state of an escrow agreement
    enum EscrowStatus { Created, Funded, Released, Cancelled, Disputed }

    // Structure to define an escrow agreement
    struct EscrowAgreement {
        uint256 escrowId;
        address buyer;
        address seller;
        uint256 propertyId;
        uint256 amount;
        EscrowStatus status;
        uint256 createdAt;
        uint256 updatedAt;
        uint256 disputeAt;
    }

    // Events
    event EscrowCreated(uint256 indexed escrowId, address indexed buyer, address indexed seller, uint256 propertyId, uint256 amount);
    event EscrowFunded(uint256 indexed escrowId, address indexed buyer, uint256 amount);
    event EscrowReleased(uint256 indexed escrowId, address indexed seller, uint256 amount);
    event EscrowCancelled(uint256 indexed escrowId, address indexed buyer, uint256 amount);
    event EscrowDisputed(uint256 indexed escrowId, address indexed buyer, address indexed seller, uint256 amount);

    // Function to create a new escrow agreement
    function createEscrow(address seller, uint256 propertyId, uint256 amount) external returns (uint256);

    // Function to fund an escrow agreement
    function fundEscrow(uint256 escrowId) external payable;

    // Function to release funds from an escrow agreement to the seller
    function releaseEscrow(uint256 escrowId) external;

    // Function to cancel an escrow agreement and refund the buyer
    function cancelEscrow(uint256 escrowId) external;

    // Function to dispute an escrow agreement
    function disputeEscrow(uint256 escrowId) external;

    // Function to get details of a specific escrow agreement
    function getEscrowAgreement(uint256 escrowId) external view returns (EscrowAgreement memory);

    // Function to get the number of active escrow agreements for a specific buyer
    function getActiveEscrowCount(address buyer) external view returns (uint256);

    // Function to get all escrow agreements for a specific buyer
    function getBuyerEscrows(address buyer) external view returns (EscrowAgreement[] memory);

    // Function to get all escrow agreements for a specific seller
    function getSellerEscrows(address seller) external view returns (EscrowAgreement[] memory);
}
