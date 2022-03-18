const hre = require("hardhat");
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL  } = require("../constants");

async function main() {
  const CryptoDevs = await hre.ethers.getContractFactory("CryptoDevs");
  const crypto = await CryptoDevs.deploy(METADATA_URL, WHITELIST_CONTRACT_ADDRESS);

  await crypto.deployed();

  console.log("CryptoDevs deployed to:", crypto.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
