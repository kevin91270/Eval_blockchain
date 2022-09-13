// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract SimpleToken{
    mapping(address => uint) public balances;

    /// @dev Buy token at the price of 1ETH/token.
    function buyToken() public payable {
        balances[msg.sender]+=msg.value / 1 ether;
    }

    /** @dev Send token.
     *  @param _recipient The recipient.
     *  @param _amount The amount to send.
     */
    function sendToken(address _recipient, uint _amount) public {
        require(
            balances[msg.sender] >= _amount && 
            balances[_recipient] <= balances[_recipient] + _amount
        );
        balances[msg.sender]-=_amount;
        balances[_recipient]+=_amount;
    }
}