// Load dependencies
const { ethers } = require("hardhat");
const { expect } = require("chai");

const transaction1 = {
  tokenURI: "player1_uri1",
  dataIdOnchain: "player1_dataonchain1",
  dataRegisterProof: "player1_dataregisterproof1",
  priceForSell: 1000,
};

const transaction2 = {
  tokenURI: "player1_uri2",
  dataIdOnchain: "player2_dataonchain2",
  dataRegisterProof: "player2_dataregisterproof2",
  priceForSell: 2000,
};

// Start test block
describe("UniversalNFT common functionalities", function () {
  before(async function () {
    this.NFT = await ethers.getContractFactory("UniversalNFT");
  });

  beforeEach(async function () {
    this.nft = await this.NFT.deploy();
    await this.nft.deployed();
  });

  // Test case
  it("Mint", async function () {
    const [addr1, addr2] = await ethers.getSigners();
    await this.nft
      .connect(addr1)
      .mintDataNTF(
        addr1.address,
        transaction1.tokenURI,
        transaction1.dataIdOnchain,
        transaction1.dataRegisterProof
      );
    expect(
      (await this.nft.connect(addr2).getTokenPrice(1)).toString()
    ).to.equal("0");
  });

  it("Set token price", async function () {
    const [addr1, addr2] = await ethers.getSigners();
    await this.nft
      .connect(addr1)
      .mintDataNTF(
        addr1.address,
        transaction1.tokenURI,
        transaction1.dataIdOnchain,
        transaction1.dataRegisterProof
      );
    await this.nft.connect(addr2).setTokenPrice(1, 1000);
    expect(
      (await this.nft.connect(addr1).getTokenPrice(1)).toString()
    ).to.equal("1000");
  });

  // it("Change Price", async function () {
  //   const [addr1, addr2] = await ethers.getSigners();
  //   await this.nft
  //     .connect(addr1)
  //     .mintDataNTF(
  //       addr1.address,
  //       transaction1.tokenURI,
  //       transaction1.dataIdOnchain,
  //       transaction1.dataRegisterProof
  //     );
  //   await expect(
  //     this.nft.connect(addr2).changeTokenPrice(1, 20000)
  //   ).to.be.revertedWith("You are not the owner of this item!");
  // });
});
