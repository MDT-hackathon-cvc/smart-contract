import { ethers } from "hardhat";

export const loadContract = (name: string, address: string) => {
  return ethers.getContractAt(name, address);
};
