// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibERC20} from "../libraries/LibERC20.sol";




contract AjidokwuFaucet{
    LibERC20.Layout ajidokwu;

	

	function init () external{
	 ajidokwu.symbol = "AJI";
	 ajidokwu.name = "Ajidokwu";
	 ajidokwu.totalSupply = 10000;
		/* i.e the deployer will be the owner at first he can then transfer tokens to any 
		other account addresses and he will have all the tokens in his wallet at first.*/
		
		balances[msg.sender] = ajidokwu.totalSupply;
		ajidokwu.owner = msg.sender;
	}
        mapping (address => uint256) balances;
     modifier onlyOwner() {
        require(msg.sender == ajidokwu.owner, "Only the owner can call this function");
        _; // Continue with the function if the sender is the owner
    }

	function transfer(address to, uint256 amount) external {
        ajidokwu.to =to;
        ajidokwu.amount=amount;
		require(balances[msg.sender]>=ajidokwu.amount, "Not enough tokens");

		

		balances[to] += ajidokwu.amount;
		balances[msg.sender] -= ajidokwu.amount;

	}

	function balanceOf(address account) external  returns (uint256) {
        ajidokwu.account = account;
		return balances[ajidokwu.account];
	}

    function mint(address to, uint256 amount) external onlyOwner {
        ajidokwu.to = to;
        ajidokwu.amount = amount;
        require(ajidokwu.totalSupply + ajidokwu.amount >= ajidokwu.totalSupply, "OverFlow detected");
        balances[to] += ajidokwu.amount;
        ajidokwu.totalSupply += ajidokwu.amount;
    }

    function burn(uint256 amount) external   {
        ajidokwu.amount = amount;
        	require(balances[msg.sender]>= ajidokwu.amount, "Not enough tokens");
            balances[msg.sender] -= ajidokwu.amount;
            ajidokwu.totalSupply -= ajidokwu.amount;
    }

	function deposit() public payable {
		require(msg.sender != address(0), "caller is 0 address");
		balances[msg.sender] += msg.value;
	}

    function name11() public view returns (string  memory l) {
        return ajidokwu.name;
        
    }
    function name1() public view returns (LibERC20.Layout memory l) {
        l.name = ajidokwu.name;
        l.symbol = ajidokwu.symbol;
        l.totalSupply = ajidokwu.totalSupply;
        
    }
}

