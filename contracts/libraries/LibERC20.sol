// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library LibERC20 {
    struct Layout {
        address owner;
        address to;
        uint256 value;
        address from;
        address spender;
        uint256 balance;
        uint256 remaining;
        address account;
        uint256 amount;
        string name;
        string symbol;
        uint256 totalSupply;
        // mapping (address => uint256) balances;
        
    }
}
