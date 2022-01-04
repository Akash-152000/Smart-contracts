pragma solidity 0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract SimpleWallet is Ownable{

    mapping(address => uint) public allowance;

    function addAllowance(address _who, uint _amount){
        allowance[_who] = _amount;
    }


    function withdrawMoney(address payable _to, uint _amount) public onlyOwner{
        _to.transfer(_amount);
    }

    receive() external payable {

    }

}
