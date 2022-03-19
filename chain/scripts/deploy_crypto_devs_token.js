const hre = require("hardhat");
const { NFT_CONTRACT_ADDRESS } = require("../constants");

async function main() {
  const CryptoDevsToken = await hre.ethers.getContractFactory("CryptoDevsToken");
  console.log(NFT_CONTRACT_ADDRESS)
  const cryptoToken = await CryptoDevsToken.deploy(NFT_CONTRACT_ADDRESS);

  await cryptoToken.deployed();

  console.log("CryptoDevsToken deployed to:", cryptoToken.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
