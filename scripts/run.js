const main = async () => {
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({value: hre.ethers.utils.parseEther("0.1"),});
    await waveContract.deployed();
    console.log("Contract addy:", waveContract.address);

    /*
    * get contract balance
     */
    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);

    console.log(
      "Contract balance:" ,
      hre.ethers.utils.formatEther(contractBalance)
    );
    /*
    *lets try two waves now
     */

    const waveTxn1 = await waveContract.wave("this is wave #1");
    await waveTxn1.wait();

    const waveTxn2 = await waveContract.wave("this is wave #1");
    await waveTxn2.wait();

    let waveCount;
    waveCount = await waveContract.getTotalWaves();
    console.log(waveCount.toNumber());

    /**
   * Let's send a few waves!
   */


    /*
    * get contract balance to see what happened
    */

    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(
      "contract balance:",
      hre.ethers.utils.formatEther(contractBalance)
    )

    const [_, randomPerson] =  await hre.ethers.getSigners();
    waveTxn = await waveContract.connect(randomPerson).wave("Another message!");
    await waveTxn.wait(); //wait for the transaction to be mined

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);

};

  
  const runMain = async () => {
    try {
      await main();
      process.exit(0); // exit Node process without error
    } catch (error) {
      console.log(error);
      process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
    }
    // Read more about Node exit ('process.exit(num)') status codes here: https://stackoverflow.com/a/47163396/7974948
  };
  
  runMain();