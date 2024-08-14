// Import necessary Hardhat libraries
const { ethers } = require("hardhat");

async function main() {
  // Get the list of accounts from Hardhat
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy the Marketplace contract
  const Marketplace = await ethers.getContractFactory("Marketplace");
  const marketplace = await Marketplace.deploy();
  await marketplace.deployed(); // Wait for deployment to finish
  console.log("Marketplace contract deployed to:", marketplace.address);

  // Deploy the Property contract
  const Property = await ethers.getContractFactory("Property");
  const property = await Property.deploy();
  await property.deployed(); // Wait for deployment to finish
  console.log("Property contract deployed to:", property.address);

  // Deploy the Shares contract
  const Shares = await ethers.getContractFactory("Shares");
  const shares = await Shares.deploy();
  await shares.deployed(); // Wait for deployment to finish
  console.log("Shares contract deployed to:", shares.address);

  // Deploy the Escrow contract
  const Escrow = await ethers.getContractFactory("Escrow");
  const escrow = await Escrow.deploy();
  await escrow.deployed(); // Wait for deployment to finish
  console.log("Escrow contract deployed to:", escrow.address);
}

// Execute the main function and handle errors
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
