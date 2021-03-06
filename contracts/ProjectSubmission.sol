pragma solidity ^0.5.0;

contract ProjectSubmission {

  address payable public owner = msg.sender;
  uint public ownerBalance;

    event registration_message(string message);
    event avaliable_status_message(string message);
    event submit_project_message(string message);
    event submit_review_message(string message);
    event withdrawl_success(string message);


    modifier onlyOwner(){
      require(msg.sender == owner, "You are not the owner of this contract!");
      _;
    }

    struct University {
        bool available;
        bool isregistered;
        uint balance;
    }
    mapping(address => University) public universities;

    enum ProjectStatus { Waiting, Rejected, Approved, Disabled }

    struct Project {
         address payable author;
         address payable university;
         ProjectStatus status;
         bool issubmitted;
         uint balance;
     }

    mapping (bytes32 => Project) public projects;


    function registerUniversity(address university_address) public onlyOwner{ // Step 1

      University memory university = University(true, true, 0);
      universities[university_address] = university;
      emit registration_message("Succesfully Registred!");

    }

    function disableUniversity(address university_address) public onlyOwner {
       //Already disabled
      if(!universities[university_address].available){
          revert("This university has already been disabled.");
      }else{
         universities[university_address].available = false;
         emit avaliable_status_message("This University has been disabled for project submissions");
      }
    }

    function submitProject(bytes32 document_hash, address payable university_address) public payable { // Step 2 and 4
    require(msg.value >= 1 ether, "A value of atleast 1 ether is required to submit a project.");
    //A university must be registred to accept project submissions
    require(universities[university_address].isregistered, "Projects can only be submitted to registred universities.");
    //A university must be available to accept project submissions
    require(universities[university_address].available, "Projects can only be submitted to available universities.");
    //A project cannot be submitted more than once
    if(projects[document_hash].issubmitted){
        revert("This project has already been submitted.");
    }


    Project memory project = Project(msg.sender, university_address, ProjectStatus.Waiting, true, 0);
    projects[document_hash] = project;
    ownerBalance += 1 ether;
    emit submit_project_message("Project Succesfully submitted!");

    }

    function disableProject (bytes32 document_hash) public onlyOwner{ // Step 3
    projects[document_hash].status = ProjectStatus.Disabled;
    }

    function reviewProject (bytes32 document_hash, ProjectStatus project_status) public onlyOwner {
    if (projects[document_hash].status == ProjectStatus.Disabled){
            revert("This project has been disabled and can no longer be reviewed.");
        }
    require(projects[document_hash].status == ProjectStatus.Waiting,"A project must be in waiting status in order to be reviewed.");
    if(project_status == ProjectStatus.Approved || project_status == ProjectStatus.Rejected ){
        projects[document_hash].status = ProjectStatus(project_status);
        emit submit_review_message("Project Successfully reviewed!");
    }else{
        emit submit_review_message("Error submitting Project review!");
    }


    }

    function donate(bytes32 document_hash) public payable { // Step 4
     if (projects[document_hash].status == ProjectStatus.Disabled){
       revert("This project has been disabled and is no longer accepting donations.");
   }

    require(projects[document_hash].status == ProjectStatus.Approved,"A project must be approved in order accept donations. Please review.");
     //70% to the project
     projects[document_hash].balance += msg.value * 7 / 10;
     //20% to the university
     universities[projects[document_hash].university].balance = msg.value * 2 / 10;
    //10% to the university
    ownerBalance += msg.value * 1 / 10;
    }


    //Only Universities and contract owners can withdraw using this function
    function withdraw() public payable { // Step 5


    //The contract owner wants to withdraw
    if(msg.sender == owner){
      uint amount = ownerBalance;
      require(amount > 0, "You have no funds to withdraw");
      ownerBalance = 0;
      msg.sender.transfer(amount);
      emit withdrawl_success("Withdrawl Successful!");
    }

    //A University wants to withdraw
    else if(!universities[msg.sender].available || universities[msg.sender].available){
      uint amount = universities[msg.sender].balance;
      require(amount > 0, "You have no funds to withdraw");
      universities[msg.sender].balance = 0;
      msg.sender.transfer(amount);
      emit withdrawl_success("Withdrawl Successful!");
    }else{
        revert("You are not permitted to use this withdraw function!");
    }

    }

    //A student wants to withdraw
    function withdraw(bytes32 document_hash) public payable {  // Step 5 (Overloading Function)
    uint amount = projects[document_hash].balance;
    projects[document_hash].balance = 0;
    msg.sender.transfer(amount);
    emit withdrawl_success("Withdrawl Successful!");
    }
}