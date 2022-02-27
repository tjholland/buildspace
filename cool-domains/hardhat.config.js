require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

module.exports = {
  solidity: "0.8.10",
  networks: {
    mumbai: {
      url: process.env.ALCHEMY_MUMBAI_KEY,
      accounts: [process.env.PRIVATE_KEY],
    }
  }
};