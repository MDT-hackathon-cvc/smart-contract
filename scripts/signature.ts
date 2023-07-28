import { ethers } from "ethers";
import { toUtf8Bytes } from "ethers/lib/utils";

const verifySignature = async (address: string, signature: string) => {
  const message = ethers.utils.solidityKeccak256(["address"], [address]);

  const result = ethers.utils.verifyMessage(
    ethers.utils.arrayify(message),
    signature
  );
  console.log(result);
};

const address = "0x680fb9c4C15c335CDf67B5e0f0BF63E4E0db0B3E";

const signature =
  "0x0fd1088a7875113afc20f99c574ee940094332697f7440484896fc9b8a949eaa7fd88c48f7531f3a9850b3f83a6212068b8b4cd1a1a4b551f2ac1ec1e84ecdd21c";
verifySignature(address, signature);
