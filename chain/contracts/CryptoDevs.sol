import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is Ownable, ERC721Enumerable {
  string _baseTokenURI;
  uint256 public _price = 0.01 ether;

  // _paused is used to pause the contract in case of an emergency
  bool public _paused;

  // max number of CryptoDevs
  uint256 public maxTokenIds = 20;

  // total number of tokenIds minted
  uint256 public tokenIds;

  // boolean to keep track of when presale started
  bool public presaleStarted;

  // timestamp for when presale would end
  uint256 public presaleEnded;

  IWhitelist whitelist;

  modifier onlyNotPaused() {
    require(!_paused, "Contract currently paused");
    _;
  }

  constructor(string memory baseURI, address whitelistContract) ERC721("Crypto Devs", "CD") {
    _baseTokenURI = baseURI;
    whitelist = IWhitelist(whitelistContract);
  }

  function startPreSale() public onlyOwner {
    presaleStarted = true;
    presaleEnded = block.timestamp + 5 minutes;
  }

  function presaleMint() public payable onlyNotPaused {
    require(presaleStarted && block.timestamp < presaleEnded);
    require(whitelist.whitelistedAddresses(msg.sender));
    require(tokenIds < maxTokenIds);
    require(msg.value >= _price);
    tokenIds += 1;
    _safeMint(msg.sender, tokenIds);
  }

  function mint() public payable onlyNotPaused {
    require(presaleStarted && block.timestamp >= presaleEnded, "not  ended");
    require(tokenIds < maxTokenIds);
    require(msg.value >= _price);
    tokenIds += 1;
    _safeMint(msg.sender, tokenIds);
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

  function setPaused(bool val) public onlyOwner {
    _paused = val;
  }

  function withDraw() public onlyOwner {
    address _owner = owner();
    uint256 amount = address(this).balance;
    (bool sent,  ) = _owner.call{value: amount}("");
    require(sent, "Failed to send Ether");
  }

  // Function to receive Ether. msg.data must be empty
  receive() external payable {}

  // Fallback function is called when msg.data is not empty
  fallback() external payable {}
}

