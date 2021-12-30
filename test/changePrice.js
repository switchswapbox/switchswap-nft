// Load dependencies
const { ethers } = require("hardhat");
const { expect } = require("chai");

const provider = ethers.provider;

const transaction1 = {
  tokenURI: "player1_uri1",
  dataIdOnchain: "player1_dataonchain1",
  dataRegisterProof: "player1_dataregisterproof1",
};

const transaction2 = {
  tokenURI: "player1_uri2",
  dataIdOnchain: "player2_dataonchain2",
  dataRegisterProof: "player2_dataregisterproof2",
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

  it("Set/Get token price", async function () {
    const [addr1, addr2] = await ethers.getSigners();
    await this.nft
      .connect(addr1)
      .mintDataNTF(
        addr1.address,
        transaction1.tokenURI,
        transaction1.dataIdOnchain,
        transaction1.dataRegisterProof
      );
    await this.nft.connect(addr1).setTokenPrice(1, 1000);
    expect(
      (await this.nft.connect(addr2).getTokenPrice(1)).toString()
    ).to.equal("1000");
  });

  it("Withdraw without money", async function () {
    const [addr1] = await ethers.getSigners();
    await expect(this.nft.connect(addr1).withdraw()).to.be.revertedWith(
      "No money left to withdraw"
    );
  });

  it("Deposit and withdraw", async function () {
    const [addr1] = await ethers.getSigners();
    await this.nft.connect(addr1).deposit({ value: 1000 });
    expect(
      (await this.nft.connect(addr1).depositOf(addr1.address)).toString()
    ).to.equal("1000");

    await this.nft.connect(addr1).withdraw();
    expect(
      (await this.nft.connect(addr1).depositOf(addr1.address)).toString()
    ).to.equal("0");
  });

  it("Token selling", async function () {
    const [addr1, addr2] = await ethers.getSigners();
    await this.nft.connect(addr1).deposit({ value: 100000000000000 });
    await this.nft
      .connect(addr2)
      .mintDataNTF(
        addr2.address,
        transaction2.tokenURI,
        transaction2.dataIdOnchain,
        transaction2.dataRegisterProof
      );

    await this.nft.connect(addr2).setTokenPrice(1, 100000000000000);
    await this.nft.connect(addr2).approve(addr1.address, 1);
    const addr2Init = await provider.getBalance(addr2.address);
    await this.nft.connect(addr1).purchaseToken(1, { value: 100000000000000 });
    const addr2Final = await provider.getBalance(addr2.address);
    console.log(addr2Final - addr2Init);
    expect(
      (await this.nft.connect(addr2).depositOf(addr2.address)).toString()
    ).to.equal("1000");
  });
});
