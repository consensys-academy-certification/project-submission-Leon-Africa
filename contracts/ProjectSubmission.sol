pragma solidity ^0.5.0;

contract ProjectSubmission {

  address payable public owner = msg.sender;
  uint public ownerBalance;

    event registration_message(string message);
    string message_success = "Succesfully Registred!";
     //error message is specifically abstract to avoid showing account info
    string message_failed = "Failed Registration - please contact info@universityregitration.org";
    
    event avaliable_status_message(string message);
    string message_unavaliable = "Succesfully changed univeristy status to unavaliable!";
    string message_immutable = "Cannot undo immutable action of set to unavaliable - please contact info@universityregitration.org";
   
    event submit_project_message(string message);
    string submit_project_success = "Project Successfully submitted!";

    event submit_review_message(string message);
    string submit_review_success = "Project Review Status succefuly updated!";
    string submit_review_error = "Error: Review status must either be Rejected or Approved.";

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
         uint balance;
     }
    
    mapping (bytes32 => Project) public projects;

    
    function registerUniversity(address university_address) public onlyOwner{ // Step 1
     
     //A university that is already registred cannot register again
     if (universities[university_address].isregistered == true){
        emit registration_message(message_failed);
     }
     //If the university is not yet registered then register it. Booleans are false by default
     else if (universities[university_address].isregistered == false){
          University memory university = University(true, true, 0);
          universities[university_address] = university;
          emit registration_message(message_success);

     }else {
       emit registration_message(message_failed);
     }
     

    }
    
    function disableUniversity(address university_address) public onlyOwner {
      
      //https://github.com/consensys-academy-certification/project-submission-Leon-Africa/issues/6
      //Action performed by disableUniversity() cannot be undone
      if(universities[university_address].available = false){
        emit avaliable_status_message(message_immutable);
      }else{
         universities[university_address].available = false;
         emit avaliable_status_message(message_unavaliable);
      }
      
      

    }
    
    function submitProject(bytes32 document_hash, address payable university_address) public payable { // Step 2 and 4
    require(msg.value >= 1 ether, "A value of atleast 1 ether is required to submit a project.");
    //A university must be registred to accept project submissions
    require(universities[university_address].isregistered, "Projects can only be submitted to registred universities.");
    //A university must be available to accept project submissions
    require(universities[university_address].available, "Projects can only be submitted to available universities.");

    Project memory project = Project(msg.sender, university_address, ProjectStatus.Waiting, 0);
    projects[document_hash] = project;
    ownerBalance += 1 ether;
    emit submit_project_message(submit_project_success);
    
    }
    
    function disableProject (bytes32 document_hash) public onlyOwner{ // Step 3
    projects[document_hash].status = ProjectStatus.Disabled;
    }
    
    function reviewProject (bytes32 document_hash, ProjectStatus project_status) public onlyOwner {
    require(projects[document_hash].status == ProjectStatus.Waiting,"A project must be in waiting status in order to be reviewed.");
    if(project_status == ProjectStatus.Approved || project_status == ProjectStatus.Rejected ){
        projects[document_hash].status = ProjectStatus(project_status);
        emit submit_review_message(submit_review_success);
    }else{
        emit submit_review_message(submit_review_error);
    }
    

    }
    
    function donate(bytes32 document_hash) public payable { // Step 4
     require(projects[document_hash].status == ProjectStatus.Approved,"A project must be in approved status in order accept donations.");
     //70% to the project
     projects[document_hash].balance += msg.value * 7 / 10;
     //20% to the university
     //universities[projects[document_hash].university].balance = msg.value * 2 / 10;
    //10% to the university
    ownerBalance += msg.value * 1 / 10;
    }
    
    // function withdraw... { // Step 5
    //   ...
    // }
    
    // function withdraw... {  // Step 5 (Overloading Function)
    //   ...
    // }
}