import {ethers} from 'hardhat';
import {CRYPTO_DEVS_NFT_CONTRACT_ADDRESS} from '../constants';

async function main() {
  const cryptoDevTokenContract = await ethers.getContractFactory('CryptoDevToken');
  const deployedCryptoDevTokenContract = await cryptoDevTokenContract.deploy(CRYPTO_DEVS_NFT_CONTRACT_ADDRESS);
  await deployedCryptoDevTokenContract.deployed();
  console.log(`Crypto Dev Token Contract Address: ${deployedCryptoDevTokenContract.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});