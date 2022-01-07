pragma solidity 0.8.7;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable {

    mapping(address => uint) public allowance;

    event allowanceChanged(address indexed _forWho, address indexed _fromWhom, uint _oldAmount, uint _newAmount);
    
    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }

    function addAllowance(address _who, uint _amount) public onlyOwner {
        emit allowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed!");
        _;
    }

    function reduceAllowance(address _who, uint _amount) internal {
        emit allowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
        allowance[_who] -= _amount;
        
    }
}

contract SharedWallet is Allowance {
    

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Contract doesn't own enough money");
        if(!isOwner()){
            reduceAllowance(msg.sender,_amount);
        }
        _to.transfer(_amount);
    }

    receive() external payable {

    }
}
