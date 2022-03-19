//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevsNFT.sol";

contract CryptoDevsToken is Ownable, ERC20 {
  uint256 public constant tokenPrice = 0.001 ether;

  uint256 public constant tokensPerNFT = 10 * 10**18;
  // the max total supply is 10000 for Crypto Dev Tokens
  uint256 public constant maxTotalSupply = 10000 * 10**18;

  ICryptoDevsNFT nftContract;
  //nft token id claim coins
  mapping(uint256 => bool) public tokenIdsClaimed;

  constructor(address _nftContractAddress) ERC20("Crypto Dev Token", "CD")  {
    nftContract = ICryptoDevsNFT(_nftContractAddress);
  }

  /**
   * @dev Mints `amount` number of CryptoDevTokens
   * Requirements:
   * - `msg.value` should be equal or greater than the tokenPrice * amount
   */
  function mint(uint256 amount) public payable {
    uint256 _requiredEthAmount = tokenPrice * amount;
    require(msg.value >= _requiredEthAmount, "Ether sent is incorrect.");

    uint256 amountWithDecimals = amount * 10**18;
    require((totalSupply() + amountWithDecimals) <= maxTotalSupply, "Exceeds the max total supply available.");
    _mint(msg.sender, amountWithDecimals);
  }

  function claim() public {
    address sender = msg.sender;
    uint256 balance = nftContract.balanceOf(sender);
    require(balance > 0, "You dont own any Crypto Dev NFT's");

    uint256 amount = 0;
    for(uint256 i = 0; i < balance; i += 1) {
      uint256 tokenId = nftContract.tokenOfOwnerByIndex(sender, i);
      if (!tokenIdsClaimed[tokenId]) {
        amount += 1;
        tokenIdsClaimed[tokenId] = true;
      }
    }
    require(amount > 0, "you already claim all coins.");
    _mint(sender, amount * tokensPerNFT);
  }

  // Function to receive Ether. msg.data must be empty
  receive() external payable {}

  // Fallback function is called when msg.data is not empty
  fallback() external payable {}
}
