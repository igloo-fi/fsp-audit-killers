require("dotenv").config()
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";


/**
 * @type import("hardhat/config").HardhatUserConfig
 */
const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: `https://goerli.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  }
};

export default config;
