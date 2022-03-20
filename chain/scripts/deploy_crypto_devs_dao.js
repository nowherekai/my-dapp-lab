const hre = require("hardhat");
const { NFT_CONTRACT_ADDRESS, FAKE_NFT_MARKET_ADDRESS } = require("../constants");

async function main() {
  const CryptoDevsDAO = await hre.ethers.getContractFactory("CryptoDevsDAO");
  console.log(NFT_CONTRACT_ADDRESS)
  console.log(FAKE_NFT_MARKET_ADDRESS)
  const cryptoDevsDAO = await CryptoDevsDAO.deploy(NFT_CONTRACT_ADDRESS, FAKE_NFT_MARKET_ADDRESS);

  await cryptoDevsDAO.deployed();

  console.log("CryptoDevsDAO deployed to:", cryptoDevsDAO.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
