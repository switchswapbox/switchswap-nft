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
describe("UniversalNFT/UniversalSwapNFT common functionalities", function () {
  before(async function () {
    this.NFT = await ethers.getContractFactory("UniversalNFT");
    this.SwapNFT = await ethers.getContractFactory("UniversalSwapNFT");
  });

  beforeEach(async function () {
    this.nft = await this.NFT.deploy();
    await this.nft.deployed();
    this.swapNft = await this.SwapNFT.deploy();
    await this.swapNft.deployed();
  });

  // Test case
  it("Mint", async function () {
    const [addr1] = await ethers.getSigners();
    await this.nft
      .connect(addr1)
      .mintDataNTF(
        addr1.address,
        transaction1.tokenURI,
        transaction1.dataIdOnchain,
        transaction1.dataRegisterProof
      );
    expect((await this.nft.ownerOf(1)).toString()).to.equal(addr1.address);
  });

  it("Deposit token", async function () {
    const [addr1, addr2] = await ethers.getSigners();
    await this.nft
      .connect(addr1)
      .mintDataNTF(
        addr1.address,
        transaction1.tokenURI,
        transaction1.dataIdOnchain,
        transaction1.dataRegisterProof
      );
    await this.nft.connect(addr1).approve(this.swapNft.address, 1);
    await this.swapNft.connect(addr1).depositToken(this.nft.address, 1, 1000);
    expect(
      (
        await this.swapNft
          .connect(addr2)
          .getTokenPrice(this.nft.address, addr1.address, 1)
      ).toString()
    ).to.equal("1000");
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
    await this.nft.connect(addr1).approve(this.swapNft.address, 1);
    await this.swapNft.connect(addr1).depositToken(this.nft.address, 1, 1000);
    await this.swapNft.connect(addr1).setTokenPrice(this.nft.address, 1, 9999);
    expect(
      (
        await this.swapNft
          .connect(addr2)
          .getTokenPrice(this.nft.address, addr1.address, 1)
      ).toString()
    ).to.equal("9999");
  });

  it("Withdraw token", async function () {
    const [addr1, addr2] = await ethers.getSigners();
    await this.nft
      .connect(addr1)
      .mintDataNTF(
        addr1.address,
        transaction1.tokenURI,
        transaction1.dataIdOnchain,
        transaction1.dataRegisterProof
      );
    await this.nft.connect(addr1).approve(this.swapNft.address, 1);
    await this.swapNft.connect(addr1).depositToken(this.nft.address, 1, 1000);
    await this.swapNft.connect(addr1).withdrawToken(this.nft.address, 1);
    expect(
      this.swapNft
        .connect(addr2)
        .getTokenPrice(this.nft.address, addr1.address, 1)
    ).to.be.revertedWith("Token invalide or has been withdrawn!");
  });

  // it("Token selling", async function () {
  //   const [addr1, addr2] = await ethers.getSigners();
  //   await this.nft
  //     .connect(addr1)
  //     .deposit({ value: ethers.BigNumber.from(100000000000000000000n) });
  //   await this.nft
  //     .connect(addr2)
  //     .mintDataNTF(
  //       addr2.address,
  //       transaction2.tokenURI,
  //       transaction2.dataIdOnchain,
  //       transaction2.dataRegisterProof
  //     );

  //   await this.nft
  //     .connect(addr2)
  //     .setTokenPrice(1, ethers.BigNumber.from(100000000000000000000n));
  //   const addr2Init = await provider.getBalance(addr2.address);
  //   await this.nft.connect(addr1).purchaseToken(1, {
  //     value: ethers.BigNumber.from(100000000000000000000n),
  //   });
  //   const addr2Final = await provider.getBalance(addr2.address);
  //   console.log(
  //     addr2Init.toString(),
  //     addr2Final.toString(),
  //     addr2Final - addr2Init
  //   );
  // });
});
