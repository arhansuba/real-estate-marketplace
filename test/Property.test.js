const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Property Contract", function () {
  let Property;
  let property;
  let owner;
  let otherAccount;

  beforeEach(async function () {
    [owner, otherAccount] = await ethers.getSigners();

    // Deploy the Property contract
    Property = await ethers.getContractFactory("Property");
    property = await Property.deploy();
    await property.deployed();
  });

  describe("Deployment", function () {
    it("Should deploy with the correct owner", async function () {
      expect(await property.owner()).to.equal(owner.address);
    });
  });

  describe("Functionality", function () {
    it("Should allow the owner to add a property", async function () {
      const propertyId = 1;
      const propertyDetails = "Property Details";

      await property.connect(owner).addProperty(propertyId, propertyDetails);
      
      const propertyInfo = await property.getProperty(propertyId);
      expect(propertyInfo.details).to.equal(propertyDetails);
      expect(propertyInfo.owner).to.equal(owner.address);
    });

    it("Should allow the owner to update property details", async function () {
      const propertyId = 1;
      const initialDetails = "Initial Property Details";
      const updatedDetails = "Updated Property Details";

      await property.connect(owner).addProperty(propertyId, initialDetails);
      await property.connect(owner).updateProperty(propertyId, updatedDetails);

      const propertyInfo = await property.getProperty(propertyId);
      expect(propertyInfo.details).to.equal(updatedDetails);
    });

    it("Should not allow non-owners to update property details", async function () {
      const propertyId = 1;
      const propertyDetails = "Property Details";

      await property.connect(owner).addProperty(propertyId, propertyDetails);

      await expect(
        property.connect(otherAccount).updateProperty(propertyId, "New Details")
      ).to.be.revertedWith("Not authorized to update property");
    });

    it("Should allow retrieval of property details", async function () {
      const propertyId = 1;
      const propertyDetails = "Property Details";

      await property.connect(owner).addProperty(propertyId, propertyDetails);

      const propertyInfo = await property.getProperty(propertyId);
      expect(propertyInfo.details).to.equal(propertyDetails);
    });

    it("Should emit PropertyAdded event when a property is added", async function () {
      const propertyId = 1;
      const propertyDetails = "Property Details";

      await expect(
        property.connect(owner).addProperty(propertyId, propertyDetails)
      ).to.emit(property, "PropertyAdded")
        .withArgs(propertyId, propertyDetails, owner.address);
    });

    it("Should emit PropertyUpdated event when a property is updated", async function () {
      const propertyId = 1;
      const propertyDetails = "Initial Property Details";
      const updatedDetails = "Updated Property Details";

      await property.connect(owner).addProperty(propertyId, propertyDetails);

      await expect(
        property.connect(owner).updateProperty(propertyId, updatedDetails)
      ).to.emit(property, "PropertyUpdated")
        .withArgs(propertyId, updatedDetails);
    });
  });
});
