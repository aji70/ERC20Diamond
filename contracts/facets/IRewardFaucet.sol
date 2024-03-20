// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRewardFaucet {
    function init() external;
    function transfer(address to, uint256 amount) external returns (bool success, address);
    function balanceOf(address account) external view returns (uint256);
    function mint(address to, uint256 amount) external;
    function transferFrom(address from, address to, uint256 value) external returns (bool success);
    function name11() external view returns (string memory);
    function approve(address spender, uint256 value) external returns (bool success);
}
