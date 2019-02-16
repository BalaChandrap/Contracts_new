pragma solidity ^0.4.19;

contract MultiSig {
  address[] public owners; 
  uint256 public required; 

  struct Transaction{
    address destinationAddress;
    uint256 valueInWei;
    bool    transactionStatus;
    bytes   data;
  }

  uint256 public transactionCount;
  mapping (uint256=>Transaction)public transactions;

  mapping (uint256=> mapping(address=>bool)) public confirmations;
  mapping (uint256=>address[]) public transactionConfirmations;
  mapping (address=>bool) public validOwners;


  function MultiSig(address[] _owners,uint256 _requiredConfirmations) public{
      require(_owners.length>=_requiredConfirmations&&
                _requiredConfirmations>=1);
      owners = _owners;
      for(uint i=0;i<owners.length;i++){
        validOwners[owners[i]] = true;
       }
      required = _requiredConfirmations;
  }

  function addTransaction(address _destinationAddress,uint256 _value,bytes _data) internal returns(uint256){
    require(_destinationAddress!=address(0));
      transactions[transactionCount] = Transaction(_destinationAddress,_value,false,_data);
      return transactionCount++;
  } 

  function confirmTransaction(uint256 _txnID) public{

     require(validOwners[msg.sender]==true); 


     require(transactions[_txnID].destinationAddress!=address(0));

     require(confirmations[_txnID][msg.sender]==false);

    confirmations[_txnID][msg.sender] = true;
    transactionConfirmations[_txnID].push(msg.sender);

      if(isConfirmed(_txnID)){
        executeTransaction(_txnID);
      }
  }
  function getConfirmations(uint256 _txnID) public view returns(address[]){
    
    return transactionConfirmations[_txnID];
  }

  function submitTransaction(address _destinationAddress,uint256 _value,bytes _data) public{
     uint256 txnID =  addTransaction(_destinationAddress,_value,_data);
      confirmTransaction(txnID);
  }

  function () public payable {

  }

  function isConfirmed(uint256 _txnID) public view returns(bool){
    uint temp = transactionConfirmations[_txnID].length;
    if(temp>=required)
    return true;
    else
    return false;
  }

  function executeTransaction(uint256 _txnID) public returns(bool) {
    require(transactions[_txnID].transactionStatus == false);
    bool temp = isConfirmed(_txnID);
    if(temp){
      transactions[_txnID].destinationAddress.transfer(transactions[_txnID].valueInWei);
      transactions[_txnID].transactionStatus = true;
      return true;
    }
    else{
      revert();
    }
    return false;
  }

  function getTransactionCount(bool _pending,bool _executed) public view returns(uint256 temp){
    bool _type;
    if(_pending)
    _type = false;
    else
    _type = true;
    for(uint i=0;i<transactionCount;i++){
      if(transactions[i].transactionStatus==_type){
        temp++;
      }
    }
  }

  function getTransactionIds(bool _pending,bool _executed) public view returns(uint256[]){

    uint count;
    for(uint i = 0; i < transactionCount; i++) {
        if(_pending && !transactions[i].transactionStatus) {
            count++;
        }
        else if(_executed && transactions[i].transactionStatus) {
            count++;
        }
    }
    uint[] memory ids = new uint[](count);
    uint idsCount = 0;
    for(uint j = 0; j < transactionCount; j++) {
        if(_pending && !transactions[j].transactionStatus) {
            ids[idsCount] = j;
            idsCount++;
        }
        else if(_executed && transactions[j].transactionStatus) {
            ids[idsCount] = j;
            idsCount++;
        }
    }
    return ids;
  }

  function getOwners() public view returns(address[]){
    return owners;
  }

}

