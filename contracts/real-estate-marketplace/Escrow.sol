// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "../interfaces/IProperty.sol";
import "../interfaces/IShares.sol";

contract Escrow is Ownable, Pausable {
    using Math for uint256;

    enum EscrowState { Pending, Completed, Disputed, Refunded }

    struct Transaction {
        address buyer;
        address seller;
        uint256 basketId;
        uint256 amount;
        EscrowState state;
        uint256 createdAt;
        uint256 updatedAt;
        string disputeReason;
    }

    uint256 public transactionCount;
    mapping(uint256 => Transaction) public transactions;

    IProperty public propertyContract;
    IShares public sharesContract;

    event TransactionCreated(uint256 transactionId, address indexed buyer, address indexed seller, uint256 basketId, uint256 amount);
    event TransactionCompleted(uint256 transactionId);
    event TransactionRefunded(uint256 transactionId);
    event TransactionDisputed(uint256 transactionId, string reason);

    modifier onlyBuyer(uint256 transactionId) {
        require(msg.sender == transactions[transactionId].buyer, "Not authorized");
        _;
    }

    modifier onlySeller(uint256 transactionId) {
        require(msg.sender == transactions[transactionId].seller, "Not authorized");
        _;
    }

    modifier onlyPending(uint256 transactionId) {
        require(transactions[transactionId].state == EscrowState.Pending, "Transaction is not pending");
        _;
    }

    constructor(address _propertyContract, address _sharesContract) Ownable(msg.sender) {
    propertyContract = IProperty(_propertyContract);
    sharesContract = IShares(_sharesContract);
    _pause(); // Initialize the contract in a paused state
}

    function createTransaction(address seller, uint256 basketId) external payable whenNotPaused {
    require(msg.value > 0, "Amount must be greater than 0");
    IShares.ShareBasket memory basket = sharesContract.getBasketDetails(basketId);
    require(basket.totalShares > 0, "Invalid basket");
    
    transactionCount++;
    transactions[transactionCount] = Transaction({
        buyer: msg.sender,
        seller: seller,
        basketId: basketId,
        amount: msg.value,
        state: EscrowState.Pending,
        createdAt: block.timestamp,
        updatedAt: block.timestamp,
        disputeReason: ""
    });

    emit TransactionCreated(transactionCount, msg.sender, seller, basketId, msg.value);
}

    function completeTransaction(uint256 transactionId) external onlySeller(transactionId) onlyPending(transactionId) {
        Transaction storage txn = transactions[transactionId];
        txn.state = EscrowState.Completed;
        payable(txn.seller).transfer(txn.amount);
        
        // Issue shares to the buyer
        sharesContract.issueShares(txn.basketId, txn.buyer, txn.amount);
        
        txn.updatedAt = block.timestamp;

        emit TransactionCompleted(transactionId);
    }

    function refundTransaction(uint256 transactionId) external onlyBuyer(transactionId) onlyPending(transactionId) payable {
        Transaction storage txn = transactions[transactionId];
        txn.state = EscrowState.Disputed;
        payable(txn.buyer).transfer(txn.amount);
        txn.updatedAt = block.timestamp;

        emit TransactionRefunded(transactionId);
    }

    function disputeTransaction(uint256 transactionId, string calldata reason) external onlyBuyer(transactionId) onlyPending(transactionId) {
        Transaction storage txn = transactions[transactionId];
        txn.state = EscrowState.Disputed;
        txn.disputeReason = reason;
        txn.updatedAt = block.timestamp;

        emit TransactionDisputed(transactionId, reason);
    }

    function resolveDispute(uint256 transactionId, bool approve) external onlyOwner payable {
        Transaction storage txn = transactions[transactionId];
        require(txn.state == EscrowState.Disputed, "Transaction is not disputed");

        if (approve) {
            txn.state = EscrowState.Completed;
            payable(txn.seller).transfer(txn.amount);
            sharesContract.issueShares(txn.basketId, txn.buyer, txn.amount);
            emit TransactionCompleted(transactionId);
        } else {
            txn.state = EscrowState.Refunded;
            payable(txn.buyer).transfer(txn.amount);
            emit TransactionRefunded(transactionId);
        }
        txn.updatedAt = block.timestamp;
    }

    function getTransaction(uint256 transactionId) external view returns (
        address buyer,
        address seller,
        uint256 basketId,
        uint256 amount,
        EscrowState state,
        uint256 createdAt,
        uint256 updatedAt,
        string memory disputeReason
    ) {
        Transaction storage txn = transactions[transactionId];
        return (
            txn.buyer,
            txn.seller,
            txn.basketId,
            txn.amount,
            txn.state,
            txn.createdAt,
            txn.updatedAt,
            txn.disputeReason
        );
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
