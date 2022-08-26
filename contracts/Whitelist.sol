//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Whitelist {
  // Max number of whitelisted addresses allowed
  uint8 public maxWhitelistedAddresses;

  mapping(address => bool) public whitelistedAddresses;
  uint8 public numAddressesWhitelisted;

  constructor(uint8 _maxWhitelistedAddresses) {
    maxWhitelistedAddresses = _maxWhitelistedAddresses;
  }

  function addAddressToWhitelist() public {
    // check if the user has already been whitelisted
    require(!whitelistedAddresses[msg.sender], 'Sender has already been whitelisted');
    // check if the numAddressesWhitelisted < maxWhitelistedAddresses, if not then throw an error.
    require(numAddressesWhitelisted < maxWhitelistedAddresses, 'Cant add more addresses , limit reached');

    whitelistedAddresses[msg.sender] = true;
    numAddressesWhitelisted++;
  }
}