import { assert, expect } from "chai";
import { deploy, deployProxy } from "../scripts/deploy";
import { ethers } from "hardhat";
import { token } from "../typechain-types/@openzeppelin/contracts";
import { BigNumber } from "ethers";

const ZERO_ADDRESS = ethers.constants.AddressZero;

describe("Mint", function () {
  // Generate mock data
  before(async function () {
    [this.deployer, this.user_1, this.user_2] = await ethers.getSigners();
    console.log(this.user_1.address, this.user_2.address);
    this.marketplace = await deployProxy("NFTMarketplace");
    this.collection_721 = await deploy("MDT721", [this.marketplace.address]);
    this.collection_1155 = await deploy("MDT1155", [this.marketplace.address]);

    // Set default collections
    await this.marketplace.setDefaultCollection(
      this.collection_721.address,
      true
    );

    await this.marketplace.setDefaultCollection(
      this.collection_1155.address,
      true
    );

    await this.marketplace.setRecipient(this.deployer.address);

    await this.marketplace.setFee(50);
  });

  it("Marketplace must be deployed", function () {
    console.log("marketplace:", this.marketplace.address);
    assert(this.marketplace.address != ZERO_ADDRESS);
  });

  it("Collection 721 must be deployed", function () {
    assert(this.collection_721.address != ZERO_ADDRESS);
  });

  it("Collection 1155 must be deployed", function () {
    assert(this.collection_1155.address != ZERO_ADDRESS);
  });

  it("2 collections must be set as default", async function () {
    expect(
      await this.marketplace.defaultCollections(this.collection_721.address)
    ).to.be.true;
    expect(
      await this.marketplace.defaultCollections(this.collection_1155.address)
    ).to.be.true;
  });

  it("NFT must be minted successfully", async function () {
    const tokenId = 1;
    const amount = 1;
    const uri = "test";
    // Mint new NFT
    await this.marketplace
      .connect(this.user_1)
      .mint(this.collection_721.address, tokenId, amount, uri);
    expect(await this.collection_721.ownerOf(tokenId)).to.equal(
      this.user_1.address
    );
  });

  it("Create order must be successful", async function () {
    const collection = this.collection_721.address;
    const tokenId = 1;
    const amount = 1;
    const paymentToken = ZERO_ADDRESS;
    const originalPrice = 0.1;
    const price = BigNumber.from(
      (originalPrice * 10 ** 18).toString()
    ).toString();
    console.log(originalPrice);

    // Approve the marketplace contract for transferring NFT
    await this.collection_721
      .connect(this.user_1)
      .approve(this.marketplace.address, tokenId);

    // Create order
    const tx = await this.marketplace
      .connect(this.user_1)
      .createOrder(collection, tokenId, amount, paymentToken, price);

    const txReceipt = await ethers.provider.getTransactionReceipt(tx.hash);
    console.log(txReceipt.logs);
    expect(await this.collection_721.ownerOf(tokenId)).to.equal(
      this.marketplace.address
    );
  });

  it("Buy NFT must be successful", async function () {
    const orders = await this.marketplace.getAllOrders();

    console.log("all orders", orders);

    const originalPrice = 0.1;
    const price = BigNumber.from(
      (originalPrice * 10 ** 18).toString()
    ).toString();

    const tx = await this.marketplace
      .connect(this.user_1)
      .buy(orders[0], 1, { value: price });

    console.log(tx);
    console.log(
      "txReceipt",
      (await ethers.provider.getTransactionReceipt(tx.hash)).logs[1]
    );
  });

  it("Cancel order must be successful", async function () {
    console.log(await this.marketplace.getAllOrders());

    const orders = await this.marketplace.getAllOrders();

    const tx = await this.marketplace
      .connect(this.user_1)
      .cancelOrder(orders[0]);

    console.log(
      "txReceipt",
      (await ethers.provider.getTransactionReceipt(tx.hash)).logs
    );

    console.log(await this.marketplace.getAllOrders());
    expect((await this.marketplace.getAllOrders()).length).to.equal(0);

    expect(await this.collection_721.ownerOf(1)).to.equal(this.user_1.address);
  });
});
