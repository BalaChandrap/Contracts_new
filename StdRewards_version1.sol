pragma solidity >=0.4.0 <0.6.0;

contract Students {
    
    struct Std {
       address stdAddress;
       string name;
       uint8  percentage;
       address createdBy;
       uint8   status; // 0-default, 1- created, 2- accepted, 3- updated
    }
    
    address  public admin;
    address tempAdmin;
    uint8 public count;
    
    uint256 public fee;
    
    constructor () public{
        fee = 1 ether;
        admin = msg.sender;
    }
    
    uint8 highestPercentage;
    address payable highestPerStd;
    
    mapping (address => Std) public studentRecords;
    
    mapping (address => bool) teachers;
    
    modifier onlyAdmin {
        
        require(msg.sender==admin);
        _;
    }
    
    modifier onlyTeachers {
        
        require(teachers[msg.sender] || msg.sender==admin);
        _;
    }
    
    function changeAdmin(address _newAdmin) public onlyAdmin{
        tempAdmin = _newAdmin;
    }
    
    function acceptAdmin() public {
        require(msg.sender == tempAdmin);
        admin = tempAdmin;
    }
    
    function addTeacher(address _newTeacher) public onlyAdmin {
        teachers[_newTeacher] = true;
    }
    
    function removeTeacher(address _teacherAddress) public onlyAdmin {
        teachers[_teacherAddress] = false;
    }
    
    function addStudent(address payable   _stdAddress,string memory _name,uint8  _percentage) public onlyTeachers {
        
        Std memory temp = Std(_stdAddress,_name,0,msg.sender,1);
        studentRecords[_stdAddress] = temp;
        count++;
        
        if(highestPercentage<_percentage){
            highestPercentage = _percentage;
            highestPerStd = address(_stdAddress);
        }
        
    }
    
    function updatePercentage(address _stdAddress,uint8 _percentage) public onlyTeachers {
        
        require(studentRecords[_stdAddress].status==2);
        studentRecords[_stdAddress].percentage = _percentage;
        studentRecords[_stdAddress].status = 3;
    }
    
    function accept() public payable{
        require(msg.value == 1 ether);
        require(studentRecords[msg.sender].stdAddress != address(0));
        studentRecords[msg.sender].status = 2;
    } 
    
    function reward() public onlyAdmin {
        
        uint256 valueInWei = (count*(1 ether/1 wei))/2;
        highestPerStd.transfer(valueInWei);
    }
    
    
    
    
    
}
