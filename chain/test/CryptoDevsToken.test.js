const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CryptoDevsToken", function () {
  it("Should mint", async function () {
    const Whitelist = await hre.ethers.getContractFactory("Whitelist");
    const whitelist = await Whitelist.deploy(10);
    await whitelist.deployed();

    const CryptoDevs = await hre.ethers.getContractFactory("CryptoDevs");
    const crypto = await CryptoDevs.deploy("localhost", whitelist.address);
    await crypto.deployed();

    const CryptoDevsToken = await hre.ethers.getContractFactory("CryptoDevsToken");
    const cryptoToken = await CryptoDevsToken.deploy(crypto.address);
    await cryptoToken.deployed();

    let [addr1, addr2] = await ethers.getSigners();
    await expect(cryptoToken.connect(addr2).mint(1)).to.be.reverted;
    let txn = await cryptoToken.connect(addr2).mint(1, {value: ethers.utils.parseEther("0.001") });
    await txn.wait();
    let balance = await cryptoToken.balanceOf(addr2.address);
    expect(balance/(10**18)).to.eq(1);
  });
});
