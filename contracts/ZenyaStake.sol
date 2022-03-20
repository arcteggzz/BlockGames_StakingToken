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
}