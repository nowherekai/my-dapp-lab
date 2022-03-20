const hre = require("hardhat");

async function main() {
  const FakeNFTMarketplace = await hre.ethers.getContractFactory("FakeNFTMarketplace");
  const market = await FakeNFTMarketplace.deploy();

  await market.deployed();

  console.log("FakeNFTMarketplace deployed to:", market.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
