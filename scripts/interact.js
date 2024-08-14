const { ethers } = require("hardhat");

async function main() {
  // Get the list of accounts from Hardhat
  const [deployer] = await ethers.getSigners();
  console.log("Interacting with contracts using the account:", deployer.address);

  // Replace these addresses with the addresses of your deployed contracts
  const marketplaceAddress = "YOUR_MARKETPLACE_CONTRACT_ADDRESS";
  const propertyAddress = "YOUR_PROPERTY_CONTRACT_ADDRESS";
  const sharesAddress = "YOUR_SHARES_CONTRACT_ADDRESS";
  const escrowAddress = "YOUR_ESCROW_CONTRACT_ADDRESS";

  // Get contract instances
  const Marketplace = await ethers.getContractFactory("Marketplace");
  const marketplace = Marketplace.attach(marketplaceAddress);

  const Property = await ethers.getContractFactory("Property");
  const property = Property.attach(propertyAddress);

  const Shares = await ethers.getContractFactory("Shares");
  const shares = Shares.attach(sharesAddress);

  const Escrow = await ethers.getContractFactory("Escrow");
  const escrow = Escrow.attach(escrowAddress);

  // Example interaction with the Marketplace contract
  console.log("Fetching marketplace details...");
  // Replace with actual function calls and arguments
  const marketplaceDetails = await marketplace.someFunction();
  console.log("Marketplace details:", marketplaceDetails);

  // Example interaction with the Property contract
  console.log("Fetching property details...");
  const propertyId = 1; // Replace with actual property ID
  const propertyDetails = await property.getPropertyDetails(propertyId);
  console.log("Property details:", propertyDetails);

  // Example interaction with the Shares contract
  console.log("Issuing shares...");
  // Replace with actual function arguments
  await shares.issueShares(1, deployer.address, 100); // Property ID, address, number of shares
  console.log("Shares issued");

  // Example interaction with the Escrow contract
  console.log("Fetching escrow details...");
  // Replace with actual function calls and arguments
  const escrowDetails = await escrow.someFunction();
  console.log("Escrow details:", escrowDetails);
}

// Execute the main function and handle errors
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
