async function main() {
    const CarbonCredit = await ethers.getContractFactory("CarbonCredit");
    const contract = await CarbonCredit.deploy();
    await contract.waitForDeployment();
  
    console.log("CarbonCredit deployed to:", await contract.getAddress());
  }
  
  main().catch((error) => {
    console.error(error);
    process.exit(1);
  });
  