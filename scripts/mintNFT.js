async function main() {
  const address = "0xE3e49B506F93357f5dC8Ce8C8338f794518c2ef2";
  const UniversalNFT = await ethers.getContractFactory("UniversalNFT");
  const universalNFT = await UniversalNFT.attach(address);

  const tokenId = await universalNFT.mintUniversalNTF(
    "0x6d26C405BB919643AfA2c89e8A138d2015b3A62F",
    "ABC",
    "CDE"
  );
  console.log(tokenId);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
