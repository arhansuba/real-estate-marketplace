const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Marketplace Contract", function () {
  let Marketplace;
  let marketplace;
  let owner;
  let seller;
  let buyer;
  let otherAccount;

  beforeEach(async function () {
    [owner, seller, buyer, otherAccount] = await ethers.getSigners();

    // Deploy the Marketplace contract
    Marketplace = await ethers.getContractFactory("Marketplace");
    marketplace = await Marketplace.deploy();
    await marketplace.deployed();
  });

  describe("Deployment", function () {
    it("Should deploy with the correct owner", async function () {
      expect(await marketplace.owner()).to.equal(owner.address);
    });
  });

  describe("Functionality", function () {
    it("Should allow the owner to add a property", async function () {
      const propertyId = 1;
      const propertyPrice = ethers.utils.parseEther("1.0"); // 1 ETH
      
      await marketplace.connect(owner).addProperty(propertyId, propertyPrice);
      
      const property = await marketplace.properties(propertyId);
      expect(property.price).to.equal(propertyPrice);
      expect(property.seller).to.equal(owner.address);
      expect(property.isListed).to.be.true;
    });

    it("Should allow the seller to list a property for sale", async function () {
      const propertyId = 1;
      const propertyPrice = ethers.utils.parseEther("1.0"); // 1 ETH

      await marketplace.connect(owner).addProperty(propertyId, propertyPrice);
      await marketplace.connect(owner).listProperty(propertyId, propertyPrice);

      const property = await marketplace.properties(propertyId);
      expect(property.isListed).to.be.true;
    });

    it("Should allow a buyer to purchase a property", async function () {
      const propertyId = 1;
      const propertyPrice = ethers.utils.parseEther("1.0"); // 1 ETH

      await marketplace.connect(owner).addProperty(propertyId, propertyPrice);
      await marketplace.connect(owner).listProperty(propertyId, propertyPrice);

      await marketplace.connect(buyer).purchaseProperty(propertyId, {
        value: propertyPrice
      });

      const property = await marketplace.properties(propertyId);
      expect(property.isListed).to.be.false; // Property should no longer be listed
      expect(await ethers.provider.getBalance(owner.address)).to.be.gt(
        ethers.utils.parseEther("100.0") // Check if owner’s balance increased
      );
    });

    it("Should not allow non-owner to add a property", async function () {
      const propertyId = 1;
      const propertyPrice = ethers.utils.parseEther("1.0"); // 1 ETH
      
      await expect(
        marketplace.connect(otherAccount).addProperty(propertyId, propertyPrice)
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });

    it("Should only allow listing a property if it is owned", async function () {
      const propertyId = 1;
      const propertyPrice = ethers.utils.parseEther("1.0"); // 1 ETH
      
      await marketplace.connect(owner).addProperty(propertyId, propertyPrice);

      await expect(
        marketplace.connect(otherAccount).listProperty(propertyId, propertyPrice)
      ).to.be.revertedWith("Only the owner can list the property");
    });

    it("Should not allow purchase of an unlisted property", async function () {
      const propertyId = 1;
      const propertyPrice = ethers.utils.parseEther("1.0"); // 1 ETH

      await marketplace.connect(owner).addProperty(propertyId, propertyPrice);

      await expect(
        marketplace.connect(buyer).purchaseProperty(propertyId, {
          value: propertyPrice
        })
      ).to.be.revertedWith("Property is not listed for sale");
    });

    it("Should emit PropertyListed event when a property is listed", async function () {
      const propertyId = 1;
      const propertyPrice = ethers.utils.parseEther("1.0"); // 1 ETH

      await marketplace.connect(owner).addProperty(propertyId, propertyPrice);
      
      await expect(
        marketplace.connect(owner).listProperty(propertyId, propertyPrice)
      ).to.emit(marketplace, "PropertyListed")
        .withArgs(propertyId, propertyPrice);
    });

    it("Should emit PropertyPurchased event when a property is purchased", async function () {
      const propertyId = 1;
      const propertyPrice = ethers.utils.parseEther("1.0"); // 1 ETH

      await marketplace.connect(owner).addProperty(propertyId, propertyPrice);
      await marketplace.connect(owner).listProperty(propertyId, propertyPrice);

      await expect(
        marketplace.connect(buyer).purchaseProperty(propertyId, {
          value: propertyPrice
        })
      ).to.emit(marketplace, "PropertyPurchased")
        .withArgs(propertyId, buyer.address);
    });
  });
});
