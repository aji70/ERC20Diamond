// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library LibReward {
    struct Layout {
        address owner;
        address to;
        address from;
        address spender;
        uint256 balance;
        // uint balances;
        // uint allowed;
        uint256 remaining;
        address account;
        uint256 amount;
        string name;
        string symbol;
        uint256 totalSupply;
        mapping (address => uint256) balances;
        mapping(address => mapping(address => uint256))  allowed;
        
    }
}
