import { ethers } from "hardhat";

export const changeMinter = async (
  name: string,
  address: string,
  newMinter: string
) => {
  const contract = await ethers.getContractAt(name, address);
  const setting = await contract.changeMinter(newMinter);
  await setting.wait();

  console.log(`Minter was changed to ${newMinter}`);
};
