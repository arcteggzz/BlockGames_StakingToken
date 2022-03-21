// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ZenyaStake is ERC20, Ownable  {
    //initialize a owwner variable to hold the address of the owner
    address public _owner;
    //initialize a token price variable to hold the price of the token(rate) in wei
    uint256 public _buyTokenPrice;
    //initialize a token price variable to hold the price of the token(rate) in ether
    uint256 public zenyaPerEth;
    //mapping holds the address and amont staked for each staker
    mapping(address => uint256) internal stakes;
    //mapping holds the address of stakers in an array
    address[] internal stakeholders;
    //The accumulated rewards for each stakeholder.
    mapping(address => uint256) internal rewards;

    constructor() ERC20("ZenyaStake", "ZNYS") {
        _mint(msg.sender, 1000 * 10 ** decimals());
    }

    //function sets the buy price of the token
    //only the owwner can set the price
    function setTokenBuyPrice (uint256 buyPrice) public {
        require(msg.sender == _owner, "Only the Owner can set the price of the token");
        _buyTokenPrice = buyPrice;
    }

    //function allows an address to buy tokens based on the rate specified
    //function caller has to input an address as a parameter
    function buyToken(address receiver) public payable{
        //set the rate to a value in ether (it is in wei currenly)
        zenyaPerEth  = _buyTokenPrice * 10**decimals();
        //create a variable to track the amount of tokens to mint to the receiver address
        uint256 amountMintable = (msg.value * zenyaPerEth) / 10**decimals();
        //call mint function to transfer funds to correct address
        _mint(receiver, amountMintable);
    }

    //STAKE FUNCTIONS
    //STAKE FUNCTIONS
    //STAKE FUNCTIONS

    //A method to check if an address is a stakeholder.
    function isStakeholder(address _address) public view returns(bool, uint256) {
       for (uint256 s = 0; s < stakeholders.length; s += 1) {
           if (_address == stakeholders[s]) return (true, s);
        }
        return (false, 0);
    }

    //A method to add a stakeholder.
    function addStakeholder(address _stakeholder) public {
       (bool _isStakeholder, ) = isStakeholder(_stakeholder);
       if(!_isStakeholder) stakeholders.push(_stakeholder);
    }

    //A method to remove a stakeholder.
    function removeStakeholder(address _stakeholder) public {
        (bool _isStakeholder, uint256 s) = isStakeholder(_stakeholder);
        if(_isStakeholder){
            stakeholders[s] = stakeholders[stakeholders.length - 1];
            stakeholders.pop();
        }
    }

    //A method to retrieve the stake for a stakeholder.
    function stakeOf(address _stakeholder) public view returns(uint256) {
        return stakes[_stakeholder];
    }

    //A method for a stakeholder to create a stake.
    function createStake(uint256 _stake) public {
        _burn(msg.sender, _stake);
        if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
        stakes[msg.sender] = stakes[msg.sender] + _stake;
    }

    //A method for a stakeholder to remove a stake.
    function removeStake(uint256 _stake) public {
        stakes[msg.sender] = stakes[msg.sender] - _stake;
        if(stakes[msg.sender] == 0) removeStakeholder(msg.sender);
        _mint(msg.sender, _stake);
    }

    //REWWARDS
    //REWWARDS
    //REWWARDS
    
    //A method to allow a stakeholder to check his rewards.
    function rewardOf(address _stakeholder) public view returns(uint256) {
        return rewards[_stakeholder];
    }

    //A method to the aggregated rewards from all stakeholders.
    function totalRewards() public view returns(uint256){
        uint256 _totalRewards = 0;
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            _totalRewards = _totalRewards + rewards[stakeholders[s]];
        }
        return _totalRewards;
    }

    //A simple method that calculates the rewards for each stakeholder.
    function calculateReward(address _stakeholder) public view returns(uint256){
        return stakes[_stakeholder] / 100;
    }

    //A method to distribute rewards to all stakeholders.
    function distributeRewards() public  {
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            address stakeholder = stakeholders[s];
            uint256 reward = calculateReward(stakeholder);
            rewards[stakeholder] = rewards[stakeholder] + reward;
        }
    }

    //A method to allow a stakeholder to withdraw his rewards.
    function withdrawReward() public {
        uint256 reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        _mint(msg.sender, reward);
    }
}