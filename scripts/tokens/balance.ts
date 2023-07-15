import { loadContract } from "./load";

const getBalance = async (address: string) => {
  const token = await loadContract(
    process.env.ERC20_NAME!,
    process.env.ERC20_TOKEN!
  );

  console.log(`${address} has ${await token.balanceOf(address)} KTK`);
};

getBalance(process.env.DEPLOYER_PUBLIC_KEY!)
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
