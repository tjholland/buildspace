const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
  
  const gameContract = await gameContractFactory.deploy(
      ['Leo', 'Aang', 'Pikachu'],         // names
      ["https://i.imgur.com/pKd5Sdk.png", // images
      "https://i.imgur.com/xVu4vFL.png", 
      "https://i.imgur.com/WMB6g9u.png"],
      [100, 200, 300],                    // hp
      [100, 50, 25],                      // attack damage values
      "Elon Musk",                        // Boss name
      "https://i.imgur.com/AksR0tt.png",  // Boss image
      10000,                              // Boss hp
      50                                  // Boss attack damage
  );

  await gameContract.deployed();
  console.log('Contract deployed to:', gameContract.address);
};

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