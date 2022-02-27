const main = async () => {
    const domainContractFactory = await hre.ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy("tron");
    await domainContract.deployed();

    console.log("Contract deployed to:", domainContract.address);

    let txn = await domainContract.register("sailor", {value: hre.ethers.utils.parseEther('0.1')});
    await txn.wait();
    console.log("Minted domain sailor.tron");

    txn = await domainContract.setRecord("sailor", "Tronification of a sailor");
    await txn.wait();
    console.log("Set record for sailor.tron");

    const address = await domainContract.getAddress("sailor");
    console.log("Owner of domain sailor:", address);

    const balance = await hre.ethers.provider.getBalance(domainContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(balance));
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();