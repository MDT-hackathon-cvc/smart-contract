import { ethers, upgrades } from "hardhat";

async function main() {
  const NFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
  const contract = await upgrades.deployProxy(NFTMarketplace, {
    initializer: "initialize",
  });
  await contract.deployed();

  console.log(`NFTMarketplace deployed at ${contract.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
