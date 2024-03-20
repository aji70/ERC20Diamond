// [11:23, 20/03/2024] Timothy WCX: /**
//      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
//      * Beware that changing an allowance with this method brings the risk that someone may use both the old
//      * and the new allowance by unfortunate transaction ordering. To mitigate this
//      * risk use increaseAllowance and decreaseAllowance to change allowances.
//      * @param spender The address which will spend the funds.
//      * @param value The amount of tokens to be spent.
//      */
//     function approve(address spender, uint256 value) public returns (bool success) {
//         allowed[msg.sender][spender] = value;
//         emit Approval(msg.sender, spender, value);
//         return true;
//     }
// [11:26, 20/03/2024] Timothy WCX: // Mapping from an account to another account with an allowance amount
//         mapping(address => mapping(address => uint256))  allowed;
// [11:34, 20/03/2024] Timothy WCX: /**
//      * @dev Event for approving an allowance.
//      * @param owner address The address of the account owning tokens
//      * @param spender address The address of the account able to transfer the tokens
//      * @param value uint256 the amount of tokens to be allowed to transfer
//      */
//     event Approval(address indexed owner, address indexed spender, uint256 value);
// [11:47, 20/03/2024] Timothy WCX: // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// /**
//  * @title ERC20 Standard Token
//  * @dev Implementation of the basic standard token.
//  * https://eips.ethereum.org/EIPS/eip-20
//  */
// contract ERC20Token {
//     // State variables
//     string public name; // Token name
//     string public symbol; // Token symbol
//     uint8 public decimals; // Number of decimals the token uses
//     uint256 public totalSupply; // Total supply of tokens

//     // Mapping from token holder address to the balance
//     mapping(address => uint256) private balances;

//     // Mapping from an account to another account with an allowance amount
//     mapping(address => mapping(address => uint256)) private allowed;

//     /**
//      * @dev Event for token transfer.
//      * @param from address The address which you want to send tokens from
//      * @param to address The address which you want to transfer to
//      * @param value uint256 the amount of tokens to be transferred
//      */
//     event Transfer(address indexed from, address indexed to, uint256 value);

//     /**
//      * @dev Event for approving an allowance.
//      * @param owner address The address of the account owning tokens
//      * @param spender address The address of the account able to transfer the tokens
//      * @param value uint256 the amount of tokens to be allowed to transfer
//      */
//     event Approval(address indexed owner, address indexed spender, uint256 value);

//     /**
//      * @dev Token constructor that sets the initial token parameters.
//      */
//     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) {
//         name = _name;
//         symbol = _symbol;
//         decimals = _decimals;
//         totalSupply = _totalSupply * 10 ** uint256(_decimals);
//         balances[msg.sender] = totalSupply; // Assign all tokens to the contract deployer
//     }

//     /**
//      * @dev Get the token balance for account tokenOwner.
//      * @param tokenOwner address The address to query the balance of
//      * @return balance uint256 bala representing the amount owned by the passed address
//      */
//     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
//         return balances[tokenOwner];
//     }

//     /**
//      * @dev Transfer token for a specified address.
//      * @param to The address to transfer to.
//      * @param value The amount to be transferred.
//      */
//     function transfer(address to, uint256 value) public returns (bool success) {
//         require(balances[msg.sender] >= value, "Insufficient balance");
//         balances[msg.sender] -= value;
//         balances[to] += value;
//         emit Transfer(msg.sender, to, value);
//         return true;
//     }

//     /**
//      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
//      * Beware that changing an allowance with this method brings the risk that someone may use both the old
//      * and the new allowance by unfortunate transaction ordering. To mitigate this
//      * risk use increaseAllowance and decreaseAllowance to change allowances.
//      * @param spender The address which will spend the funds.
//      * @param value The amount of tokens to be spent.
//      */
//     function approve(address spender, uint256 value) public returns (bool success) {
//         allowed[msg.sender][spender] = value;
//         emit Approval(msg.sender, spender, value);
//         return true;
//     }

//     /**
//      * @dev Function to check the amount of tokens that an owner allowed to a spender.
//      * @param tokenOwner address The address which owns the funds.
//      * @param spender address The address which will spend the funds.
//      * @return remaining A uint256 specifying the amount of tokens still available for the spender.
//      */
//     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
//         return allowed[tokenOwner][spender];
//     }

//     /**
//      * @dev Transfer tokens from one address to another.
//      * Note that while this function emits an Approval event, this is not required as per the specification,
//      * and other compliant implementations may not emit the event.
//      * @param from address The address which you want to send tokens from
//      * @param to address The address which you want to transfer to
//      * @param value uint256 the amount of tokens to be transferred
//      */
//     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
//     require(value <= balances[from], "Insufficient balance");
//     require(value <= allowed[from][msg.sender], "Allowance exceeded");

//     balances[from] -= value;
//     allowed[from][msg.sender] -= value;
//     balances[to] += value;
    
//     emit Transfer(from, to, value);
//     return true;
// }

// /**
//  * @dev Increase the amount of tokens that an owner allowed to a spender.
//  * This mitigates the problem described in the approve function above.
//  * @param spender The address which will spend the funds.
//  * @param addedValue The amount of tokens to increase the allowance by.
//  */
// function increaseAllowance(address spender, uint256 addedValue) public returns (bool success) {
//     allowed[msg.sender][spender] += addedValue;
//     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
//     return true;
// }

// /**
//  * @dev Decrease the amount of tokens that an owner allowed to a spender.
//  * This is the counterpart to 'increaseAllowance'.
//  * @param spender The address which will spend the funds.
//  * @param subtractedValue The amount of tokens to decrease the allowance by.
//  */
// function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool success) {
//     uint256 oldValue = allowed[msg.sender][spender];
//     if (subtractedValue >= oldValue) {
//         allowed[msg.sender][spender] = 0;
//     } else {
//         allowed[msg.sender][spender] -= subtractedValue;
//     }
//     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
//     return true;
// }

// /**
//  * @dev Internal function to mint tokens, increasing the total supply.
//  * @param account The account that will receive the created tokens.
//  * @param amount The amount of tokens that will be created.
//  */
// function _mint(address account, uint256 amount) internal {
//     require(account != address(0), "ERC20: mint to the zero address");

//     totalSupply += amount;
//     balances[account] += amount;
//     emit Transfer(address(0), account, amount);
// }

// /**
//  * @dev Internal function to burn tokens, decreasing the total supply.
//  * @param account The account from which tokens will be burned.
//  * @param amount The amount of tokens that will be burned.
//  */
// function _burn(address account, uint256 amount) internal {
//     require(account != address(0), "ERC20: burn from the zero address");
//     require(balances[account] >= amount, "ERC20: burn amount exceeds balance");

//     balances[account] -= amount;
//     totalSupply -= amount;
//     emit Transfer(account, address(0), amount);
// }

// /**
//  * @dev External function to mint tokens. Only callable by contract owner or specific authorized roles in advanced implementations.
//  * @param account The account that will receive the created tokens.
//  * @param amount The amount of tokens that will be created.
//  */
// function mint(address account, uint256 amount) public {
//     // Access control logic (e.g., require(msg.sender == owner, "Only the contract owner can mint tokens"))
//     _mint(account, amount);
// }

// /**
//  * @dev External function to burn tokens. Only callable by token holders or specific authorized roles in advanced implementations.
//  * @param amount The amount of tokens that will be burned.
//  */
// function burn(uint256 amount) public {
//     _burn(msg.sender, amount);
// }
// }