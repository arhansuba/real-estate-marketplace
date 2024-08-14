const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Shares Contract", function () {
  let Shares;
  let shares;
  let owner;
  let otherAccount;

  beforeEach(async function () {
    [owner, otherAccount] = await ethers.getSigners();

    // Deploy the Shares contract
    Shares = await ethers.getContractFactory("Shares");
    shares = await Shares.deploy();
    await shares.deployed();
  });

  describe("Deployment", function () {
    it("Should deploy with the correct owner", async function () {
      expect(await shares.owner()).to.equal(owner.address);
    });
  });

  describe("Basket Management", function () {
    it("Should allow the owner to create a basket", async function () {
      const basketId = 1;
      const propertyIds = [101, 102];
      const totalShares = 1000;

      await shares.createBasket(basketId, propertyIds, totalShares);

      const basket = await shares.getBasketDetails(basketId);
      expect(basket.basketId).to.equal(basketId);
      expect(basket.propertyIds).to.deep.equal(propertyIds);
      expect(basket.totalShares).to.equal(totalShares);
    });

    it("Should allow the owner to issue shares", async function () {
      const basketId = 1;
      const propertyIds = [101, 102];
      const totalShares = 1000;

      await shares.createBasket(basketId, propertyIds, totalShares);
      await shares.issueShares(basketId, owner.address, 500);

      const balance = await shares.balanceOf(owner.address);
      expect(balance).to.equal(500);
    });

    it("Should not allow issuing more shares than available", async function () {
      const basketId = 1;
      const propertyIds = [101, 102];
      const totalShares = 1000;

      await shares.createBasket(basketId, propertyIds, totalShares);

      await expect(
        shares.issueShares(basketId, owner.address, 1500)
      ).to.be.revertedWith("Insufficient shares available");
    });
  });

  describe("Share Transfers", function () {
    beforeEach(async function () {
      const basketId = 1;
      const propertyIds = [101, 102];
      const totalShares = 1000;

      await shares.createBasket(basketId, propertyIds, totalShares);
      await shares.issueShares(basketId, owner.address, 500);
    });

    it("Should allow transferring shares between accounts", async function () {
      await shares.transferShares(1, otherAccount.address, 200);

      const ownerBalance = await shares.balanceOf(owner.address);
      const otherAccountBalance = await shares.balanceOf(otherAccount.address);

      expect(ownerBalance).to.equal(300);
      expect(otherAccountBalance).to.equal(200);
    });

    it("Should not allow transferring more shares than owned", async function () {
      await expect(
        shares.transferShares(1, otherAccount.address, 600)
      ).to.be.revertedWith("Not enough shares to transfer");
    });
  });

  describe("Access Control", function () {
    it("Should not allow non-owners to create baskets", async function () {
      await expect(
        shares.connect(otherAccount).createBasket(2, [103, 104], 2000)
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });
  });

  describe("Events", function () {
    it("Should emit SharesIssued event when shares are issued", async function () {
      const basketId = 1;
      await shares.issueShares(basketId, owner.address, 500);

      await expect(
        shares.issueShares(basketId, owner.address, 500)
      ).to.emit(shares, "SharesIssued")
        .withArgs(owner.address, basketId, 500);
    });

    it("Should emit SharesTransferred event when shares are transferred", async function () {
      await shares.transferShares(1, otherAccount.address, 200);

      await expect(
        shares.transferShares(1, otherAccount.address, 200)
      ).to.emit(shares, "SharesTransferred")
        .withArgs(owner.address, otherAccount.address, 1, 200);
    });
  });
});
