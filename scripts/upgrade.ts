import { ethers, upgrades } from "hardhat";

export const upgrade = async (name: string) => {
  const factory = await ethers.getContractFactory(name);
  await upgrades.upgradeProxy(process.env.MARKETPLACE!, factory);

  console.log(`Upgraded`);
};

upgrade("NFTMarketplace")
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
