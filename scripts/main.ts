import { ethers } from "hardhat";
// import { deploy, deployProxy } from "./deploy";
// import { changeMinter } from "./tokens/change-minter";

// import { BigNumber, ethers } from "ethers";
import { loadContract } from "./tokens/load";

const main = async () => {
  //   await deploy("MDT721", [process.env.MARKETPLACE!]);
  //   const marketplace = await deployProxy("NFTMarketplace", []);
  //   const setting = await marketplace.setDefaultCollection(
  //     process.env.MDT_721,
  //     true
  //   );
  //   await setting.wait();
  // await changeMinter("MDT721", process.env.MDT_721!, process.env.MARKETPLACE!);

  // const provider = ethers.getDefaultProvider(process.env.RPC_ENDPOINT);
  // console.log(provider);

  const txHash =
    "0x0140c06dd3e417dbc02a1c544223c838492ca28bb5d7e0bf9058f60defdbf43a";
  const txReceipt = await ethers.provider.getTransactionReceipt(txHash);
  // console.log("txReceipt", txReceipt);

  txReceipt.logs.map((log) => console.log(log));

  // const originalPrice = 0.0001;

  // const decimal = 10 ** 18;

  // const realPrice = BigNumber.from(decimal * originalPrice).toString();
  // console.log(realPrice);

  const contract = await loadContract(
    "NFTMarketplace",
    process.env.MARKETPLACE!
  );

  const allOrders = await contract.getAllOrders();
  console.log(allOrders);

  // let setting = await contract.setRecipient(process.env.DEPLOYER_PUBLIC_KEY!);
  // await setting.wait();

  // console.log(`Recipient was set`);

  // setting = await contract.setFee(50);
  // await setting.wait();

  // console.log(`Fee was set`);
};

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });

// ["0xa751768ca19C804f24F4b6229D5c4930E1596de7"];
