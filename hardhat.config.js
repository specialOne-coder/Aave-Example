require('@nomiclabs/hardhat-waffle')
require('dotenv').config()
require('hardhat-deploy')
require('hardhat-deploy-ethers')
require('@nomiclabs/hardhat-etherscan')
require('./tasks')

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners()

  for (const account of accounts) {
    console.log(account.address)
  }
})

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.1',
  settings: {
    optimizer: {
      enabled: true,
      runs: 1,
    },
  },

  contractSizer: {
    alphaSort: false,
    runOnCompile: true,
    disambiguatePaths: false,
  },

  namedAccounts: {
    deployer: {
      default: 0, // wallet address 0, of the mnemonic Or private key in .env
    },
  },
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
    },
    goerli: {
      url: 'https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161',
      chainId: 4,
      accounts: [process.env.PRIVATE_KEY],
      // gas: 2100000,
      // gasPrice: 8000000000
    },
    mumbai: {
      url: 'https://rpc-mumbai.maticvigil.com/',
      chainId: 80001,
      accounts: [process.env.PRIVATE_KEY],
      // gas: 2100000,
      // gasPrice: 8000000000
    },
  },
  etherscan: {
    apiKey: process.env.NETWORK_API_KEY,
  },
}
