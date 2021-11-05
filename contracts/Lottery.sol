pragma solidity ^0.4.17; // specify solidity version

contract Lottery {
    address public manager;
    address[] public players;
    
    // constructor code is executed once when a contract is deployed
    function Lottery() public {
        manager = msg.sender; // will be me who creates the contract (lottery)
    }
    
    function enter() public payable {
        require(msg.value > .01 ether); // validation: at least 0.01 ether to participate in the lottery
        players.push(msg.sender);
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(block.difficulty, now, players)); // pseudo random number generator 
    }
    
    function pickWinner() public restricted {
        uint index = random() % players.length;
        players[index].transfer(this.balance); // send current balance of CA (money) to this address (winner)
        players = new address[](0); // empty player list
    }
    
    modifier restricted() {
        require(msg.sender == manager); // validation: only the manager (who created this contract) can pick a winner
        _;
    }
    
    function getPlayers() public view returns (address[]) {
        return players;
    }
}