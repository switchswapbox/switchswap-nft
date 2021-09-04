async function main() {
  const address = "0x7595C9430A1B315ae902b2Da2D95eB26AeEB5329";
  const UniversalNFT = await ethers.getContractFactory("UniversalNFT");
  const universalNFT = await UniversalNFT.attach(address);

  const tokenId = await universalNFT.mintDataNTF(
    "0x6d26C405BB919643AfA2c89e8A138d2015b3A62F",
    "https://gateway.pinata.cloud/ipfs/QmNxpDMiKJKUnVcQgxpWWz4jXiJpLAhdobBnpNGpftmxtk",
    "ipfs://QmTnE4JFony1X2LWKuuGyNQkrKDTBSiZZowquiRqCskXig",
    "crust://0xfdc3500246a8a95f8b51626f7d4627db74c327830affff7864f294917648e380"
  );
  console.log(tokenId);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
