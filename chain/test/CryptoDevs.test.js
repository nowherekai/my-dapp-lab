const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CryptoDevs", function () {
  it("Should mint", async function () {
    const Whitelist = await hre.ethers.getContractFactory("Whitelist");
    const whitelist = await Whitelist.deploy(10);
    await whitelist.deployed();

    const CryptoDevs = await hre.ethers.getContractFactory("CryptoDevs");
    const crypto = await CryptoDevs.deploy("localhost", whitelist.address);
    await crypto.deployed();
    let txn = await crypto.startPreSale();
    await txn.wait();

    let [addr1, addr2] = await ethers.getSigners();
    txn = await crypto.connect(addr2).mint();
  });
});
