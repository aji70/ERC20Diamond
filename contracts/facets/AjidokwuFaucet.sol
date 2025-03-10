// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibERC20} from "../libraries/LibERC20.sol";

contract AjidokwuFaucet {
    LibERC20.Layout ajidokwu;

    function init() external {
        ajidokwu.symbol = "AJI";
        ajidokwu.name = "Ajidokwu";
        ajidokwu.totalSupply = 1000000000000;
        /* i.e the deployer will be the owner at first he can then transfer tokens to any 
		other account addresses and he will have all the tokens in his wallet at first.*/

        ajidokwu.balances[msg.sender] = ajidokwu.totalSupply;
        ajidokwu.owner = msg.sender;
    }

    //   mapping(address => mapping(address => uint256))  allowed;
    // mapping (address => uint256) balances;
    modifier onlyOwner() {
        require(
            msg.sender == ajidokwu.owner,
            "Only the owner can call this function"
        );
        _; // Continue with the function if the sender is the owner
    }

    // function transfer(address to, uint256 amount) external {
    //     // ajidokwu.to =to;
    //     // ajidokwu.amount=amount;
    // 	require(balances[msg.sender]>=amount, "Not enough tokens");

    // 	balances[to] += ajidokwu.amount;
    // 	balances[msg.sender] -= ajidokwu.amount;

    // }

    function transfer(
        address to,
        uint256 amount
    ) public returns (bool success, address) {
        ajidokwu.to = to;
        ajidokwu.amount = amount;
        require(
            ajidokwu.balances[msg.sender] >= ajidokwu.amount,
            "Insufficient balance"
        );
        ajidokwu.balances[msg.sender] -= ajidokwu.amount;
        ajidokwu.balances[to] += ajidokwu.amount;
        // emit Transfer(msg.sender, to, value);
        return (true, msg.sender);
    }

    function balanceOf(address account) external returns (uint256) {
        ajidokwu.account = account;
        return ajidokwu.balances[account];
    }

    function mint(address to, uint256 amount) external onlyOwner {
        ajidokwu.to = to;
        ajidokwu.amount = amount;
        require(
            ajidokwu.totalSupply + ajidokwu.amount >= ajidokwu.totalSupply,
            "OverFlow detected"
        );
        ajidokwu.balances[to] += ajidokwu.amount;
        ajidokwu.totalSupply += ajidokwu.amount;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool success) {
        require(value <= ajidokwu.balances[from], "Insufficient balance");
        require(
            value <= ajidokwu.allowed[from][msg.sender],
            "Allowance exceeded"
        );

        ajidokwu.balances[from] -= value;
        ajidokwu.allowed[from][msg.sender] -= value;
        ajidokwu.balances[to] += value;

        // emit Transfer(from, to, value);
        return true;
    }

    // function burn(uint256 amount) external   {
    //     ajidokwu.amount = amount;
    //     	require(balances[msg.sender]>= ajidokwu.amount, "Not enough tokens");
    //         balances[msg.sender] -= ajidokwu.amount;
    //         ajidokwu.totalSupply -= ajidokwu.amount;
    // }

    // function deposit() public payable {
    // 	require(msg.sender != address(0), "caller is 0 address");
    // 	balances[msg.sender] += msg.value;
    // }

    function name11() public view returns (string memory l) {
        return ajidokwu.name;
    }

    // function name1() public view returns (LibERC20.Layout memory l) {
    //     l.name = ajidokwu.name;
    //     l.symbol = ajidokwu.symbol;
    //     l.totalSupply = ajidokwu.totalSupply;

    // }
    function approve(
        address spender,
        uint256 value
    ) public returns (bool success) {
        ajidokwu.spender = spender;
        ajidokwu.allowed[msg.sender][ajidokwu.spender] = value;
        // emit Approval(msg.sender, ajidokwu.spender, ajidokwu.value);
        return true;
    }
}
