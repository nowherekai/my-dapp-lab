//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Whitelist {
  uint8 public maxWhitelistedAddresses;
  mapping(address => bool) public whitelistedAddresses;
  uint8 public numAddressesWhitelisted;

  constructor(uint8 _maxWhitelistedAddresses) {
    maxWhitelistedAddresses = _maxWhitelistedAddresses;
  }

  function addAddressToWhitelist() public {
    require(!whitelistedAddresses[msg.sender]);
    require(maxWhitelistedAddresses >= numAddressesWhitelisted);

    whitelistedAddresses[msg.sender] = true;
    numAddressesWhitelisted += 1;
  }
}
