import { loadContract } from "./load";

const mint = async (to: string, amount: string) => {
  const token = await loadContract("KenToken", process.env.ERC20_TOKEN!);

  const minting = await token.mint(to, amount);
  await minting.wait();

  console.log(`Minted ${amount} to ${to}`);
};

const amount = "5000000000000000000";
mint(process.env.DEPLOYER_PUBLIC_KEY!, amount);
