

module.exports = async function ({ deployments, getNamedAccounts }) {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();
    console.log(`>>> your address: ${deployer}`)
    console.log(`On [${hre.network.name}] `)

    await deploy("ContractName", { // Put your contract name here
        from: deployer,
        args: [ ],
        log: true,
        waitConfirmations: 1,
    })

}

module.exports.tags = ["Tags Name"]; // Tags are used to filter tags
