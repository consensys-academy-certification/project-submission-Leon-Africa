/*
    This Javascript script file is to test your use and implementation of the 
    web3.js library.

    Using the web3.js library in the Javascript files of a front-end application
    will likely be similar to the implementation required here, but could
    have significant differences as well.
*/

let Web3 = require('web3')
const ProjectSubmission = artifacts.require('ProjectSubmission')
let gasAmount = 3000000

let App = {

    /*
        These state variables will be checked by the test.app.js test file. 

        Save the instantiated web3 object, ProjectSubmission contract, provided
        Ethereum account and corresponding contract state variables.

        When sending transactions to the contract, set the "from" account to
        web3.eth.defaultAccount. The default account is changed in the ../test/test.app.js
        file to simulate sending transactions from different accounts.
          - i.e. myContract.methods.myMethod({ from: web3.eth.defaultAccount ... })

        Each function in the App object should return the full transaction object provided by
        web3.js. For example 

        async myFunction(){
            let result = await myContract.myMethod({ from: web3.eth.defaultAccount ... })
            return result
        }
    */

    web3:          null,
    networkId:     null,
    contract:      null,
    account:       null,
    contractOwner: null,

    // The init() function will be called after the Web3 object is set in the test file
    // This function should update App.web3, App.networkId and App.contract
    async init() {
        //using web3.js therefore Web3.givenProvider
        App.web3 = new Web3(Web3.givenProvider || "ws://localhost:8546");
        App.networkId = await this.web3.eth.net.getId();
        App.contract = await ProjectSubmission.deployed();
       
    },

    // This function should get the account made available by web3 and update App.account
    async getAccount(){
        App.account = web3.eth.defaultAccount;
        return App.account; 
    },

    // Read the owner state from the contract and update App.contractOwner
    // Return the owner address
    async readOwnerAddress(){
        App.contractOwner = await App.contract.owner({from: web3.eth.defaultAccount})
        .on('error', console.error);
        return App.contractOwner;
    },

    // Read the owner balance from the contract
    // Return the owner balance
    async readOwnerBalance(){
        let owner_balance = await App.contract.ownerBalance({from: web3.eth.defaultAccount})
        .on('error', console.error);
        owner_balance = web3.utils.fromWei(owner_balance.toString(), "ether" );
        return owner_balance;
    },

    // Read the state of a provided University account
    // This function takes one address parameter called account    
    // Return the state object 
    async readUniversityState(account){
        let university_state = await App.contract.universities(account, {from: web3.eth.defaultAccount})
        .on('error', console.error);
        return university_state;
    },

    // Register a university when this function is called
    // This function takes one address parameter called account
    // Return the transaction object 
    async registerUniversity(account){
        
        let registered_university  = await App.contract.registerUniversity(account,  {from: web3.eth.defaultAccount, gas: gasAmount})
        .on('error', console.error);
        return registered_university

        
    },

    // Disable the university at the provided address when this function is called
    // This function takes one address parameter called account
    // Return the transaction object
    async disableUniversity(account){
        let disable_university = await App.contract.disableUniversity(account,  {from: web3.eth.defaultAccount, gas: gasAmount})
        .on('error', console.error);
        return disable_university;
    },

    // Submit a new project when this function is called
    // This function takes 3 parameters
    //   - a projectHash, an address (universityAddress), and a number (amount to send with the transaction)   
    // Return the transaction object 
    async submitProject(projectHash, universityAddress, amount){
        amount = web3.utils.toWei(web3.utils.toBN(amount));
        let submit_project = await App.contract.submitProject(projectHash, universityAddress, 
        {from: web3.eth.defaultAccount, gas: gasAmount, value: amount})
        .on('error', console.error);
        return submit_project;
    },

    // Review a project when this function is called
    // This function takes 2 parameters
    //   - a projectHash and a number (status)
    // Return the transaction object
    async reviewProject(projectHash, status){
        let review_project = await App.contract.reviewProject(projectHash, status, {from: web3.eth.defaultAccount, gas: gasAmount})
        .on('error', console.error);
        return review_project;
    },

    // Read a projects' state when this function is called
    // This function takes 1 parameter
    //   - a projectHash
    // Return the transaction object
    async readProjectState(projectHash){
            let read_project_state = await App.contract.projects(projectHash, {from: web3.eth.defaultAccount})
            .on('error', console.error);
            return read_project_state;
    },

    // Make a donation when this function is called
    // This function takes 2 parameters
    //   - a projectHash and a number (amount)
    // Return the transaction object
    async donate(projectHash, amount){
        amount = web3.utils.toWei(web3.utils.toBN(amount));
        let donation = await App.contract.donate(projectHash, {from: web3.eth.defaultAccount, gas: gasAmount, value: amount})
        .on('error', console.error);
        return donation;
    },

    // Allow a university or the contract owner to withdraw their funds when this function is called
    // Return the transaction object
    async withdraw(){
        let withdrawl = await App.contract.withdraw({from: web3.eth.defaultAccount, gas: gasAmount})
        .on('error', console.error);
        return withdrawl;
    },

    // Allow a project author to withdraw their funds when this function is called
    // This function takes 1 parameter
    //   - a projectHash
    // Use the following format to call this function: this.contract.methods['withdraw(bytes32)'](...)
    // Return the transaction object
    async authorWithdraw(projectHash){
        let author_withdrawl = await App.contract.withdraw(projectHash)
        .on('error', console.error);
        return author_withdrawl;
    }
} 

module.exports = App
