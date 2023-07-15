import { ethers } from "hardhat";

const main = async () => {
  const factory = await ethers.getContractFactory("KenToken");
  const token = await factory.deploy();
  await token.deployed();

  console.log(`Token was deployed at ${token.address}`);
};

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
