//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./IFakeNFTMarketplace.sol";
import "./ICryptoDevsNFT.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract CryptoDevsDAO is Ownable {
  IFakeNFTMarketplace nftMarketplace;
  ICryptoDevsNFT nftContract;

  struct Proposal {
    uint256 nftTokenId;
    uint256 deadline;
    uint256 yayVotes;
    uint256 nayVotes;
    bool executed;
    mapping(uint256 => bool) voters;
  }

  enum Vote {
    YAY, // YAY = 0
    NAY // NAY = 1
  }


  mapping(uint256 => Proposal) proposals;
  uint256 numProposals;

  constructor(address _nft, address _market) payable {
    nftMarketplace = IFakeNFTMarketplace(_market);
    nftContract = ICryptoDevsNFT(_nft);
  }

  modifier onlyNftHolder() {
    require(nftContract.balanceOf(msg.sender) > 0, "not a dao member");
    _;
  }

  function createProposal(uint256 _nftTokenId) onlyNftHolder external returns(uint256) {
    require(nftMarketplace.available(_nftTokenId), "NFT NOT FOR SALE");
    Proposal storage proposal = proposals[numProposals];
    proposal.nftTokenId = _nftTokenId;
    proposal.deadline = block.timestamp + 5 minutes;

    numProposals += 1;

    return numProposals - 1;
  }

  modifier onlyActiveProposal(uint256 proposalIndex) {
    require(proposals[proposalIndex].deadline > block.timestamp, "DEALINE");
    _;
  }
  
  function voteOnProposal(uint256 proposalIndex, Vote vote) external onlyNftHolder onlyActiveProposal(proposalIndex) {
    Proposal storage proposal = proposals[proposalIndex];

    uint256 voterNFTBalance = nftContract.balanceOf(msg.sender);
    uint256 numVotes = 0;

    for (uint256 i = 0; i < voterNFTBalance; i++) {
        uint256 tokenId = nftContract.tokenOfOwnerByIndex(msg.sender, i);
        if (proposal.voters[tokenId] == false) {
            numVotes++;
            proposal.voters[tokenId] = true;
        }
    }

    require(numVotes > 0, "ALREADY_VOTED");
    if (vote == Vote.YAY) {
      proposal.yayVotes += numVotes;
    } else {
      proposal.nayVotes += numVotes;
    }
  }

  modifier inactiveProposalOnly(uint256 proposalIndex) {
    require(
      proposals[proposalIndex].deadline <= block.timestamp,
      "DEADLINE_NOT_EXCEEDED"
    );
    require(
      proposals[proposalIndex].executed == false,
      "PROPOSAL_ALREADY_EXECUTED"
    );
    _;
  }

  function executeProposal(uint256 proposalIndex) external onlyNftHolder inactiveProposalOnly(proposalIndex) {
    Proposal storage proposal = proposals[proposalIndex];

    if (proposal.yayVotes > proposal.nayVotes) {
      uint256 nftPrice = nftMarketplace.getPrice();
      require(address(this).balance >= nftPrice, "NOT_ENOUGH_FUNDS");
      nftMarketplace.purchase{value: nftPrice}(proposal.nftTokenId);
    }

    proposal.executed = true;
  }

  function withdrawEther() external onlyOwner {
    payable(owner()).transfer(address(this).balance);
  }

  receive() external payable {}

  fallback() external payable {}

}
