// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

interface IWhitelist {
  function whitelistedAddresses(address) external view returns (bool);
}

contract CryptoDevs is ERC721Enumerable, Ownable {
  string _baseTokenURI;

  uint256 public _price = 0.01 ether;

  bool public _paused;

  uint256 public maxTokenIds = 20;

  uint256 public tokenIds;

  IWhitelist whitelist;

  bool public presaleStarted;

  uint256 public presaleEnd;

  modifier onlyWhenNotPaused {
    require(!_paused, 'Contract currently paused');
    _;
  }

  constructor(string memory baseURI, address whitelistContract) ERC721('Crypto Devs', 'CRD') {
    _baseTokenURI = baseURI;
    whitelist = IWhitelist(whitelistContract);
  }

  function startPresale() public onlyOwner {
    presaleStarted = true;
    presaleEnd = block.timestamp + 5 minutes;
  }

  function presaleMint() public payable onlyWhenNotPaused {
    require(presaleStarted && block.timestamp < presaleEnd, 'Presale is not running');
    require(whitelist.whitelistedAddresses(msg.sender), 'You are not in the whitelist');
    require(tokenIds < maxTokenIds, 'Exceeded maximum Crypto Devs supply');
    require(msg.value >= _price, 'The amount of ether is low');
    tokenIds++;

    _safeMint(msg.sender, tokenIds);
  }

  function mint() public payable onlyWhenNotPaused {
    require(presaleStarted && block.timestamp >= presaleEnd, 'Presale is not running');
    require(tokenIds < maxTokenIds, 'Exceeded maximum Crypto Devs supply');
    require(msg.value >= _price, 'The amount of ether is low');
    tokenIds++;

    _safeMint(msg.sender, tokenIds);
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

  function setPaused(bool val) public onlyOwner {
    _paused = val;
  }

  function withdraw() public onlyOwner {
    address _owner = owner();
    uint256 amount = address(this).balance;
    (bool sent, ) = _owner.call{value: amount}('');
    require(sent, 'Failed to send Ether');
  }

  receive() external payable {}
  fallback() external payable {}
}