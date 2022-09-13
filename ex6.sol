//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17; 
contract Token {
    mapping(address => uint) public balances;
    
    /// @dev Buy token at the price of 1ETH/token.
    function buyToken() public payable {
        balances[msg.sender]+=msg.value / 1 ether;
    }
    
    /** @dev Send token.
     *  @param _recipient The recipient.
     *  @param _amount The amount to send.
     */
    function sendToken(address _recipient, uint _amount) public  {
        require(balances[msg.sender]>=_amount); // You must have some tokens.
        require(balances[_recipient] <= (balances[_recipient] += _amount));
        balances[msg.sender]-=_amount;
        balances[_recipient]+=_amount;
    }
    
    /** @dev Send all tokens.
     *  @param _recipient The recipient.
     */
    function sendAllTokens(address _recipient) public {
        balances[_recipient]+=balances[msg.sender];
        balances[msg.sender]=0;
    }
}