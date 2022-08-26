import {ethers} from 'hardhat';

async function main() {
  const WhitelistContract = await ethers.getContractFactory("Whitelist");
  const deployedWhitelistContract = await WhitelistContract.deploy(10);

  await deployedWhitelistContract.deployed();

  console.log(`Whitelist Contract Address: ${deployedWhitelistContract.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
