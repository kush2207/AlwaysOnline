// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract GameLeaderboard is Ownable {
    using SafeMath for uint256;

    struct Player {
        uint256 highestScore;
        address payable playerAddress;
    }

    mapping(address => Player) public players;

    uint256 public submissionFee = 0.0001 ether;

    Player[] public leaderboard;

    event ScoreSubmitted(address indexed player, uint256 score);

    constructor() {}

    // Allows users to submit their highest game score
    function submitScore(uint256 score) external payable {
        require(msg.value >= submissionFee, "Insufficient fee");

        if (score > players[msg.sender].highestScore) {
            players[msg.sender].highestScore = score;
            players[msg.sender].playerAddress = payable(msg.sender);

            // Update the leaderboard
            bool playerInLeaderboard = false;
            for (uint256 i = 0; i < leaderboard.length; i++) {
                if (leaderboard[i].playerAddress == msg.sender) {
                    leaderboard[i].highestScore = score;
                    playerInLeaderboard = true;
                    break;
                }
            }

            if (!playerInLeaderboard) {
                leaderboard.push(Player(score, payable(msg.sender)));
            }
            sortLeaderboard();
        }

        emit ScoreSubmitted(msg.sender, score);
    }

    // Sorts the leaderboard by descending score
    function sortLeaderboard() internal {
        for (uint256 i = 0; i < leaderboard.length; i++) {
            for (uint256 j = i + 1; j < leaderboard.length; j++) {
                if (leaderboard[i].highestScore < leaderboard[j].highestScore) {
                    (leaderboard[i], leaderboard[j]) = (leaderboard[j], leaderboard[i]);
                }
            }
        }
    }

    // Allows anyone to view the leaderboard
    function getLeaderboard() external view returns (Player[] memory) {
        return leaderboard;
    }

    // Allows the contract owner to withdraw the contract balance
    function withdrawBalance() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
