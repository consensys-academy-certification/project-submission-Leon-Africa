pragma solidity ^0.5.0;

contract ProjectSubmission {

  address payable public owner = msg.sender;
    // ...ownerBalance... // Step 4 (state variable)

    event registration_message(string message);
    string message_success = "Succesfully Registred!";
     //error message is specifically abstract to avoid showing account info
    string message_failed = "Failed Registration - please contact info@universityregitration.org";
    
    event avaliable_status_message(string message);
    string message_unavaliable = "Succesfully changed univeristy status to unavaliable!";
    string message_immutable = "Cannot undo immutable action of set to unavaliable - please contact info@universityregitration.org";
   

    modifier onlyOwner(){
      require(msg.sender == owner, "You are not the owner of this contract!");
      _;
    }
      
    struct University { // Step 1
        bool available;
        bool isregistered;
        uint balance;
    }
    mapping(address => University) public universities;
    
    // enum ProjectStatus { ... } // Step 2
    // struct Project { // Step 2
    //     ...author...
    //     ...university...
    //     ...status...
    //     ...balance...
    // }
    // ...projects... // Step 2 (state variable)

    
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
    
    // function submitProject... { // Step 2 and 4
    //   ...
    // }
    
    // function disableProject... { // Step 3
    //   ...
    // }
    
    // function reviewProject... { // Step 3
    //   ...
    // }
    
    // function donate... { // Step 4
    //   ...
    // }
    
    // function withdraw... { // Step 5
    //   ...
    // }
    
    // function withdraw... {  // Step 5 (Overloading Function)
    //   ...
    // }
}