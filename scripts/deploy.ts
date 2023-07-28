import { ethers, upgrades } from "hardhat";

// async function main() {
//   const NFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
//   const contract = await upgrades.deployProxy(NFTMarketplace, {
//     initializer: "initialize",
//   });
//   await contract.deployed();

//   console.log(`NFTMarketplace deployed at ${contract.address}`);
// }

// // We recommend this pattern to be able to use async/await everywhere
// // and properly handle errors.
// main().catch((error) => {
//   console.error(error);
//   process.exitCode = 1;
// });

export const deploy = async (name: string, args: any = []) => {
  console.log(`Deploying ${name}...`);
  const factory = await ethers.getContractFactory(name);
  const contract = await factory.deploy(...args);
  await contract.deployed();

  console.log(`${name} was deployed at ${contract.address}`);

  return contract;
};

export const deployProxy = async (name: string, args: any = []) => {
  console.log(`Deploying proxy ${name}...`);
  const factory = await ethers.getContractFactory(name);
  const contract = await upgrades.deployProxy(factory, {
    initializer: "initialize",
  });

  await contract.deployed();
  console.log(`${name} was deployed at ${contract.address}`);

  return contract;
};

