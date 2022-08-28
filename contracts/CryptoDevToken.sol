// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ICryptoDevs {
  function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
  function balanceOf(address owner) external view returns (uint256 balance);
}

contract CryptoDevToken is ERC20, Ownable {
  uint256 public constant tokenPrice = 0.001 ether;
  uint256 public constant tokensPerNFT = 10 * 10 ** 18;
  uint256 public constant maxTotalSupply = 10000 * 10 ** 18;
  ICryptoDevs CryptoDevsNFT;
  mapping(uint256 => bool) public tokenIdsClaimed;

  constructor(address _cryptoDevsNFTContract) ERC20('Crypto Dev Token', 'CDT') {
    CryptoDevsNFT = ICryptoDevs(_cryptoDevsNFTContract);
  }

  function mint(uint256 amount) public payable {
    require(msg.value >= amount * tokenPrice, 'You must send more ethers');
    uint256 mintAmount = amount * 10 ** 18;
    require(
      totalSupply() + mintAmount <= maxTotalSupply,
      'Exceeds max total supply'
    );
    _mint(msg.sender, mintAmount);
  }

  function claim() public {
    address sender = msg.sender;
    uint nftBalance = CryptoDevsNFT.balanceOf(sender);
    require(nftBalance > 0, 'You dont own any Crypto Dev NFT');
    uint256 amount = 0;
    for (uint256 i = 0; i < nftBalance; i++) {
      uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
      if (!tokenIdsClaimed[tokenId]) {
        amount++;
        tokenIdsClaimed[tokenId] = true;
      }
    }

    require(amount > 0, 'You have already claimed all the tokens');
    _mint(sender, amount * tokensPerNFT);
  }

  function withdraw() public onlyOwner {
    address _owner = owner();
    (bool sent, ) = _owner.call{value: address(this).balance}('');
    require(sent, 'Failed to send Ether');
  }

  receive() external payable {}
  fallback() external payable {}
}