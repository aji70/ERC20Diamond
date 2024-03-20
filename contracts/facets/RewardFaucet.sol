// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibERC20} from "../libraries/LibERC20.sol";




contract RewardFaucet{
    LibERC20.Layout reward;

	

	function init () external{
	 reward.symbol = "AJI";
	 reward.name = "Reward Token";
	 reward.totalSupply = 10000;
		/* i.e the deployer will be the owner at first he can then transfer tokens to any 
		other account addresses and he will have all the tokens in his wallet at first.*/
		
		reward.balances[msg.sender] = reward.totalSupply;
		reward.owner = msg.sender;
	}
    //   mapping(address => mapping(address => uint256))  allowed;
        // mapping (address => uint256) balances;
     modifier onlyOwner() {
        require(msg.sender == reward.owner, "Only the owner can call this function");
        _; // Continue with the function if the sender is the owner
    }

	// function transfer(address to, uint256 amount) external {
    //     // reward.to =to;
    //     // reward.amount=amount;
	// 	require(balances[msg.sender]>=amount, "Not enough tokens");

		

	// 	balances[to] += reward.amount;
	// 	balances[msg.sender] -= reward.amount;

	// }

     function transfer(address to, uint256 amount) public returns (bool success, address) {
        reward.to = to;
        reward.amount = amount;
        require(reward.balances[msg.sender] >= reward.amount, "Insufficient balance");
        reward.balances[msg.sender] -= reward.amount;
        reward.balances[to] += reward.amount;
        // emit Transfer(msg.sender, to, value);
        return (true,  msg.sender);
    }
	function balanceOf(address account) external view returns (uint256) {
        // reward.account = account;
		return reward.balances[account];
	}

    function mint(address to, uint256 amount) external onlyOwner {
        reward.to = to;
        reward.amount = amount;
        require(reward.totalSupply + reward.amount >= reward.totalSupply, "OverFlow detected");
        reward.balances[to] += reward.amount;
        reward.totalSupply += reward.amount;
    }
    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
    require(value <= reward.balances[from], "Insufficient balance");
    require(value <= reward.allowed[from][msg.sender], "Allowance exceeded");

    reward.balances[from] -= value;
    reward.allowed[from][msg.sender] -= value;
    reward.balances[to] += value;
    
    // emit Transfer(from, to, value);
    return true;
}

    // function burn(uint256 amount) external   {
    //     reward.amount = amount;
    //     	require(balances[msg.sender]>= reward.amount, "Not enough tokens");
    //         balances[msg.sender] -= reward.amount;
    //         reward.totalSupply -= reward.amount;
    // }

	// function deposit() public payable {
	// 	require(msg.sender != address(0), "caller is 0 address");
	// 	balances[msg.sender] += msg.value;
	// }

    function name11() public view returns (string  memory l) {
        return reward.name;
        
    }
    // function name1() public view returns (LibERC20.Layout memory l) {
    //     l.name = reward.name;
    //     l.symbol = reward.symbol;
    //     l.totalSupply = reward.totalSupply;
        
    // }
        function approve(address spender, uint256 value) public returns (bool success) {
        reward.spender = spender;
        reward.allowed[msg.sender][reward.spender] = value;
        // emit Approval(msg.sender, reward.spender, reward.value);
        return true;
    }
}

