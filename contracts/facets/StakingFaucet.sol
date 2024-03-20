// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IERC20.sol";
import {LibStaking} from "../libraries/LibStaking.sol";
import {LibERC20} from "../libraries/LibERC20.sol";
import {LibReward} from "../libraries/LibReward.sol";


error ADDRESS_ZERO_DETECTED();
error ZERO_VALUE_DETECTED();
error NOT_ENOUGH_TOKENS();
error STAKE_TIME_MUST_BE_IN_THE_FUTURE();
error STAKE_TIME_YET_TO_ELAPSE();
error NO_STAKE_TO_WITHDRAW();
error CANNOT_STAKE_NOW_TRY_AGAIN_LATER();

contract StakingFaucet {
LibERC20.Layout ajidokwu;
LibReward.Layout reward;
LibStaking.Layout staking;
    

    
    mapping (address => uint) stakeBalance;
    mapping (address => uint) stakeDuration;
    mapping (address => uint) lastStakedTime;
    mapping (address => uint) noOfStakes;
    

    event StakingSuccessful (address staker, uint amount, uint staketime) ;
    event UnstakedSuccessful (address staker, uint stakedAmount); 
    
        function init(address _ajidokwuToken, address _rewardToken) external {
            staking.rewardToken = _rewardToken;
            staking.ajidokwuToken = _ajidokwuToken;
            staking.owner = msg.sender;
        }
        
    function stake(uint256 _amount, uint _duration) external{
        staking.amount = _amount;
        staking.duration = _duration;

        if (noOfStakes[msg.sender] != 0 && block.timestamp - lastStakedTime[msg.sender] < 10) {
        revert CANNOT_STAKE_NOW_TRY_AGAIN_LATER();
        }
            if (msg.sender == address(0)){
                revert ADDRESS_ZERO_DETECTED();
            }
        // require(msg.sender != address(0), "Address zero detected");
        if (staking.amount <= 0){
                revert ZERO_VALUE_DETECTED();
            }
        // require(_amount > 0, "Can't stake zero value");

        if(IAjidokwuFaucet(staking.ajidokwuToken).balanceOf(ajidokwu.owner) <= staking.amount){
            revert NOT_ENOUGH_TOKENS();
        }
        // require(IERC20(ajidokwuToken).balanceOf(msg.sender) >= _amount, "Not enough tokens to stake");
        if(staking.duration <= 0){
            revert STAKE_TIME_MUST_BE_IN_THE_FUTURE();
        }
        // require(_duration > 0, "Unstake time Must be in the funture");
        IAjidokwuFaucet(staking.ajidokwuToken).transferFrom(msg.sender, address(this), staking.amount);

            stakeBalance[msg.sender] += staking.amount;
            staking.totalStaked+=staking.amount;

            emit StakingSuccessful(msg.sender, staking.amount, staking.duration);
            
            uint256 inow = block.timestamp + staking.duration; 
            stakeDuration[msg.sender] = inow;
            noOfStakes[msg.sender]++;

    }
   
    function unstake() public {
        // require(msg.sender != address(0), "Address zero detected");
     if (msg.sender == address(0)){
            revert ADDRESS_ZERO_DETECTED();
        }
        if(block.timestamp <= stakeDuration[msg.sender]){
            revert STAKE_TIME_YET_TO_ELAPSE();
        }

        // require(block.timestamp >= stakeDuration[msg.sender]   , "You can't withdraw yet");
        // require(block.timestamp >= unlockTime, "You can't withdraw yet");

        if (msg.sender == address(0)){
            revert ADDRESS_ZERO_DETECTED();
        }
        if(block.timestamp <= stakeDuration[msg.sender]){
            revert STAKE_TIME_YET_TO_ELAPSE();
        }
        if(stakeBalance[msg.sender] <= 0){
            revert NO_STAKE_TO_WITHDRAW();
        }
        
        
        // require(stakeBalance[msg.sender] > 0, "No stake to withdraw");

        uint256 _stk = stakeBalance[msg.sender];
        uint time = block.timestamp - stakeDuration[msg.sender];
        staking.totalStaked -= _stk;
        stakeBalance[msg.sender] = 0;
        uint _amount = _stk + Calculatereward(_stk, time);

        IAjidokwuFaucet(staking.rewardToken).transfer(msg.sender, _amount);
        lastStakedTime[msg.sender] = block.timestamp;

        emit UnstakedSuccessful(msg.sender, _amount);
    }

     function emergencyWithdraw() public {
        if (msg.sender == address(0)){
            revert ADDRESS_ZERO_DETECTED();
        }
        
         if(stakeBalance[msg.sender] <= 0){
        revert NO_STAKE_TO_WITHDRAW();
            }
        uint amount;
        stakeBalance[msg.sender] = amount;
         staking.totalStaked -= amount;
        stakeBalance[msg.sender] = 0;

         IAjidokwuFaucet(staking.rewardToken).transfer(msg.sender, amount);
         emit UnstakedSuccessful(msg.sender, amount);
        emit UnstakedSuccessful(msg.sender, block.timestamp);
    }

    function Calculatereward(uint256 _amount, uint _timeInSec)public pure returns(uint256){
       uint256 _reward = (_amount * 7 * _timeInSec) / 100;
       return _reward;
    }

    function checkUserStakedBalance(address _user) external  returns (uint256) {
        staking.user = _user;
        return stakeBalance[staking.user];
    }
    function totalStakedBalance() external view returns (uint256) {
        return staking.totalStaked;
    }
    function _calcDuration() external   view returns(uint256, string memory){
       if(stakeBalance[msg.sender] == 0){
        return(0, "you have no stake to withdraw");
       }
       
        if((stakeDuration[msg.sender] - block.timestamp) > 1){
        return (stakeDuration[msg.sender] - block.timestamp, "Staking not Matured");
        }
        else{
            return(0, "Stake Matured");
        }
        
    }
    function returnStakeDuration(address _user) external  returns(uint256){
       staking.user = _user;
       return stakeDuration[staking.user];
    }
    
    function returnNoOfStakes() private view returns(uint256){
        
        return noOfStakes[msg.sender];
    }
    //  function layout() public view returns (LibStaking.Layout memory l) {
    //     l.owner = staking.owner;
    //     // l.symbol = staking.onetwo;
    //     // l.totalSupply = ajidokwu.totalSupply;
        
    // }
}