// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibERC20} from "../libraries/LibERC20.sol";




contract RewardFaucet{
    LibERC20.Layout reward;

	

	function init () external{
	 reward.symbol = "RWD";
	 reward.name = "Reward Token";
	 reward.totalSupply = 10000;
		/* i.e the deployer will be the owner at first he can then transfer tokens to any 
		other account addresses and he will have all the tokens in his wallet at first.*/
		
		balances[msg.sender] = reward.totalSupply;
		reward.owner = msg.sender;
	}
        mapping (address => uint256) balances;
     modifier onlyOwner() {
        require(msg.sender == reward.owner, "Only the owner can call this function");
        _; // Continue with the function if the sender is the owner
    }

	function transfer(address to, uint256 amount) external {
        reward.to =to;
        reward.amount=amount;
		require(balances[msg.sender]>=reward.amount, "Not enough tokens");

		

		balances[to] += reward.amount;
		balances[msg.sender] -= reward.amount;

	}

	function balanceOf(address account) external  returns (uint256) {
        reward.account = account;
		return balances[reward.account];
	}

    function mint(address to, uint256 amount) external onlyOwner {
        reward.to = to;
        reward.amount = amount;
        require(reward.totalSupply + reward.amount >= reward.totalSupply, "OverFlow detected");
        balances[to] += reward.amount;
        reward.totalSupply += reward.amount;
    }

    function burn(uint256 amount) external   {
        reward.amount = amount;
        	require(balances[msg.sender]>= reward.amount, "Not enough tokens");
            balances[msg.sender] -= reward.amount;
            reward.totalSupply -= reward.amount;
    }

	function deposit() public payable {
		require(msg.sender != address(0), "caller is 0 address");
		balances[msg.sender] += msg.value;
	}

    function name11() public view returns (string  memory l) {
        return reward.name;
        
    }
    function name1() public view returns (LibERC20.Layout memory l) {
        l.name = reward.name;
        l.symbol = reward.symbol;
        l.totalSupply = reward.totalSupply;
        
    }
}

