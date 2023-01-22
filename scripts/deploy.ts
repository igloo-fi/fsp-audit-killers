import { ethers } from "hardhat";


async function main() {
  const [deployer] = await ethers.getSigners();

	console.log(`Deploying contracts with the account: ${deployer.address}`);
	console.log(`Account Balance: ${await deployer.getBalance()}`);

  const FSPAuditKillers = await ethers.getContractFactory("FSPAuditKillers");
  const _FfSPAuditKillers = await FSPAuditKillers.deploy("https://");

  console.log(`_FfSPAuditKillers deployed at address: ${_FfSPAuditKillers.address}`);
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
