pragma solidity ^0.4.20;

contract Storage {
    
    mapping (bytes32 => uint) public uintMap;
    mapping (bytes32 => string) public stringMap;
    
    function storeUint(uint _value,bytes32 _key) public {
        uintMap[_key] = _value;
    }
    
    function storeString(string _value,bytes32 _key) public {
        stringMap[_key] = _value;
    }
    
}

contract Score {
    
    Storage str;
    
    function setStorage(address _storageAddress) public{
        str = Storage(_storageAddress);
    }
    
    function setScore (uint _score) public {
        str.storeUint(_score,keccak256("score"));
    }
    
    function getScore() public view returns (uint){
        return str.uintMap(keccak256("score"));
    }
}

contract Score2 {
    Storage str;
    
    function setStorage(address _storageAddress) public{
        str = Storage(_storageAddress);
    }
    
    function setScore (uint _score) public {
        str.storeUint(_score*2,keccak256("score"));
    }
    
    function setScore1 (uint _score) public {
        str.storeUint(_score*4,keccak256("score1"));
    }
    
    function getScore() public view returns (uint){
        return str.uintMap(keccak256("score"));
    }
    
    function getScore1() public view returns (uint){
        return str.uintMap(keccak256("score1"));
    }
}
