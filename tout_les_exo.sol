//*** Exercice 1 ***//

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
/////////////////////////////////////////////////////////////////////
//*** Exercice 2 ***//

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract VoteTwoChoices{
    mapping(address => uint) public votingRights;
    mapping(address => uint) public votesCast;
    mapping(bytes32 => uint) public votesReceived;

    /// @dev Get 1 voting right per ETH sent.
    function buyVotingRights() public payable {
        votingRights[msg.sender]+=msg.value/(1 ether);
    }

    /** @dev Vote with nbVotes for a proposition.
     *  @param _nbVotes The number of votes to cast.
     *  @param _proposition The proposition to vote for.
     */
    function vote(uint _nbVotes, bytes32 _proposition) public {
        require(_nbVotes + votesCast[msg.sender]<=votingRights[msg.sender]); // Check you have enough voting rights.
        require(votesCast[msg.sender] <= votesCast[msg.sender] + _nbVotes);
        require(votesReceived[_proposition] <= votesReceived[_proposition] + _nbVotes);

        votesCast[msg.sender]+=_nbVotes;
        votesReceived[_proposition]+=_nbVotes;
    }
}
/////////////////////////////////////////////////////////////////////
//*** Exercice 3 ***//

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract BuyToken {
    mapping(address => uint) public balances;
    uint public price=1;
    address public owner=msg.sender;

    /** @dev Buy tokens.
     *  @param _amount The amount to buy.
     *  @param _price  The price to buy those in ETH.
     */
    function buyVotes(uint _amount, uint _price) public payable {
        require(_price>=price); // The price is at least the current price.
        require(_amount > 0);
        require(_price * _amount / _amount == _price);
        require(_price * _amount * 1 ether /  1 ether == _price * _amount);
        require(_price * _amount * 1 ether <= msg.value); // You have paid at least the total price.
        balances[msg.sender]+=_amount;
    }

    /** @dev Set the price, only the owner can do it.
     *  @param _price The new price.
     */
    function setPrice(uint _price) public {
        require(msg.sender==owner);
        price=_price;
    }
}
/////////////////////////////////////////////////////////////////////
//*** Exercice 4 ***//

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17; 

contract Store {

    struct Safe {
        address owner;
        uint amount;
    }
    mapping(address => Safe) public safes;

    /// @dev Store some ETH.
    function store() public payable {
       require(msg.value>0,"please provide value greater than 0");
       if(safes[msg.sender].owner==address(0)){
        safes[msg.sender] = Safe({owner: msg.sender, amount: msg.value});
       }else
        safes[msg.sender].amount = safes[msg.sender].amount + msg.value;
    }

    /// @dev Take back all the amount stored.
    function take() public {
        require(safes[msg.sender].amount > 0, "insufficient balance");
        uint256 _amount = safes[msg.sender].amount;
        delete safes[msg.sender];   
        payable(msg.sender).transfer(_amount);
    }
}
/////////////////////////////////////////////////////////////////////
//*** Exercice 5 ***//

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17; 

contract CountContribution{
    mapping(address => uint) public contribution;
    uint public totalContributions;
    address owner=msg.sender;
    
    /// @dev Constructor, count a contribution of 1 ETH to the creator.
    constructor()  {
        recordContribution(owner, 1 ether);
    }
    
    /// @dev Contribute and record the contribution.
    function contribute() public payable {
        recordContribution(msg.sender, msg.value);
    }
    
    /** @dev Record a contribution. To be called by CountContribution and contribute.
     *  @param _user The user who contributed.
     *  @param _amount The amount of the contribution.
     */
    function recordContribution(address _user, uint _amount) private {
        contribution[_user]+=_amount;
        totalContributions+=_amount;
    }
}
/////////////////////////////////////////////////////////////////////
//*** Exercice 6 ***//

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
/////////////////////////////////////////////////////////////////////
//*** Exercice 7 ***//

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17; 

contract DiscountedBuy {
    uint public basePrice = 1 ether;
    mapping (address => uint) public objectBought;

    /// @dev Buy an object.
    function buy() public payable {
        require(msg.value == price());
        objectBought[msg.sender]+=1;
    }
    
    /** @dev Return the price you'll need to pay.
     *  @return price The amount you need to pay in wei.
     */
    function price() public view returns (uint) {
        return basePrice/(1 + objectBought[msg.sender]);
    }
}
/////////////////////////////////////////////////////////////////////

//*** Exercice 8 ***//
// You choose Head or Tail and send 1 ETH.
// The next party send 1 ETH and try to guess what you chose.
// If it succeed it gets 2 ETH, else you get 2 ETH.
contract HeadOrTail {
    bool public chosen; // True if head/tail has been chosen.
    bool lastChoiceHead; // True if the choice is head.
    address public lastParty; // The last party who chose.
    
    /** @dev Must be sent 1 ETH.
     *  Choose head or tail to be guessed by the other player.
     *  @param _chooseHead True if head was chosen, false if tail was chosen.
     */
    function choose(bool _chooseHead) payable {
        require(!chosen);
        require(msg.value == 1 ether);
        
        chosen=true;
        lastChoiceHead=_chooseHead;
        lastParty=msg.sender;
    }
    
    
    function guess(bool _guessHead) payable {
        require(chosen);
        require(msg.value == 1 ether);
        
        if (_guessHead == lastChoiceHead)
            msg.sender.transfer(2 ether);
        else
            lastParty.transfer(2 ether);
            
        chosen=false;
    }
}
/////////////////////////////////////////////////////////////////////
//*** Exercice 9 ***//

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17; 

contract Vault {
    mapping(address => uint) public balances;

    /// @dev Store ETH in the contract.
    function store() public payable {
        balances[msg.sender]+=msg.value;
    }
    
    /// @dev Redeem your ETH.
    function redeem() public {
        uint _balance = balances[msg.sender];
        balances[msg.sender]=0;
        payable(msg.sender).transfer(_balance);  
    }
}
/////////////////////////////////////////////////////////////////////
//*** Exercice 10 ***//

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17; 

contract HeadTail {
    address payable public partyA;
    address payable public partyB;
    bytes32 public commitmentA;
    bool public chooseHeadB;
    uint public timeB;
    
    /** @dev Constructor, commit head or tail.
     *  @param _commitmentA is keccak256(chooseHead,randomNumber);
     */
    constructor(bytes32 _commitmentA) payable {
        require(msg.value == 1 ether);
        commitmentA=_commitmentA;
        partyA=payable(msg.sender);
    }
    
    /** @dev Guess the choice of party A.
     *  @param _chooseHead True if the guess is head, false otherwize.
     */
    function guess(bool _chooseHead) public payable {
        require(msg.value == 1 ether);
        require(partyB==address(0));
        
        chooseHeadB=_chooseHead;
        timeB=block.timestamp;
        partyB=payable(msg.sender);
    }
    
    /** @dev Reveal the commited value and send ETH to the winner.
     *  @param _chooseHead True if head was chosen.
     *  @param _randomNumber The random number chosen to obfuscate the commitment.
     */
    function resolve(bool _chooseHead, uint _randomNumber) public {
        require(msg.sender == partyA);
        require(keccak256(abi.encodePacked(_chooseHead, _randomNumber)) == commitmentA);
        require(address(this).balance >= 2 ether);
        
        if (_chooseHead == chooseHeadB)
            partyB.transfer(2 ether);
        else
            partyA.transfer(2 ether);
    }
    
    /** @dev Time out party A if it takes more than 1 day to reveal.
     *  Send ETH to party B.
     * */
    function timeOut() public {
        require(block.timestamp > timeB + 1 days && partyB!=address(0));
        require(address(this).balance >= 2 ether);
        partyB.transfer(2 ether);
    }
}
/////////////////////////////////////////////////////////////////////
//*** Exercice 11 ***//

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17; 

contract VaultInvariant {
    mapping(address => uint) public balances;
    uint totalBalance;

    /// @dev Store ETH in the contract.
    function store() payable public{
        balances[msg.sender]+=msg.value;
        totalBalance+=msg.value;
    }
    
    /// @dev Redeem your ETH.
    function redeem() public {
        uint toTranfer = balances[msg.sender];
        payable(msg.sender).transfer(toTranfer);
        balances[msg.sender]=0;
        totalBalance-=toTranfer;
    }
    
    /// @dev Let a user get all funds if an invariant is broken.
    function invariantBroken() public{
        require(totalBalance!=address(this).balance);
        payable(msg.sender).transfer(address(this).balance);
    }
}
