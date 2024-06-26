// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
interface IAjidokwuFaucet {
    function init() external;
    function transfer(address to, uint256 amount) external returns (bool success, address);
    function balanceOf(address account) external view returns (uint256);
    function mint(address to, uint256 amount) external;
    function transferFrom(address from, address to, uint256 value) external returns (bool success);
    function name11() external view returns (string memory);
    function approve(address spender, uint256 value) external returns (bool success);
}
// interface IERC20 {
//     // function name() external view returns (string memory);
//     // function symbol() external view returns (string memory);
//     // function decimals() external view returns (uint8);
//     // function totalSupply() external view returns (uint256);
//     function balanceOf(address _owner) external view returns (uint256 balance);
//     function transfer(address _to, uint256 _value) external returns (bool success);
//     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
//     // function approve(address _spender, uint256 _value) external returns (bool success);
//     // function allowance(address _owner, address _spender) external view returns (uint256 remaining);

//     event Transfer(address indexed _from, address indexed _to, uint256 _value);
//     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
// }