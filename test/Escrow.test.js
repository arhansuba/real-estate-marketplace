const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Escrow Contract", function () {
  let Escrow;
  let escrow;
  let owner;
  let buyer;
  let seller;
  let otherAccount;

  beforeEach(async function () {
    [owner, buyer, seller, otherAccount] = await ethers.getSigners();

    // Deploy the Escrow contract
    Escrow = await ethers.getContractFactory("Escrow");
    escrow = await Escrow.deploy();
    await escrow.deployed();
  });

  describe("Deployment", function () {
    it("Should deploy with correct owner", async function () {
      expect(await escrow.owner()).to.equal(owner.address);
    });
  });

  describe("Functionality", function () {
    it("Should allow a buyer to deposit funds", async function () {
      const depositAmount = ethers.utils.parseEther("1.0"); // 1 ETH
      await escrow.connect(buyer).deposit({ value: depositAmount });
      
      // Verify the balance
      const escrowBalance = await ethers.provider.getBalance(escrow.address);
      expect(escrowBalance).to.equal(depositAmount);
    });

    it("Should allow the seller to withdraw funds", async function () {
      const depositAmount = ethers.utils.parseEther("1.0"); // 1 ETH
      await escrow.connect(buyer).deposit({ value: depositAmount });
      
      // Seller withdraws funds
      const sellerInitialBalance = await ethers.provider.getBalance(seller.address);
      await escrow.connect(seller).withdraw();
      
      const sellerFinalBalance = await ethers.provider.getBalance(seller.address);
      expect(sellerFinalBalance).to.be.gt(sellerInitialBalance); // Final balance should be greater
    });

    it("Should not allow non-buyer to deposit", async function () {
      const depositAmount = ethers.utils.parseEther("1.0"); // 1 ETH
      await expect(
        escrow.connect(otherAccount).deposit({ value: depositAmount })
      ).to.be.revertedWith("Only buyer can deposit");
    });

    it("Should only allow the owner to set buyer and seller", async function () {
      await escrow.connect(owner).setBuyer(buyer.address);
      await escrow.connect(owner).setSeller(seller.address);

      expect(await escrow.buyer()).to.equal(buyer.address);
      expect(await escrow.seller()).to.equal(seller.address);
      
      // Test non-owner trying to set buyer
      await expect(
        escrow.connect(buyer).setBuyer(otherAccount.address)
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });

    it("Should not allow withdrawal before setting seller", async function () {
      const depositAmount = ethers.utils.parseEther("1.0"); // 1 ETH
      await escrow.connect(buyer).deposit({ value: depositAmount });
      
      // Attempt withdrawal by seller before being set
      await expect(
        escrow.connect(seller).withdraw()
      ).to.be.revertedWith("Seller not set");
    });
  });
});
