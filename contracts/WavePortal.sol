// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 noOfWaves;
    /*
     * We will be using this below to help generate a random number
     */

    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

     /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastWavedAt;

    mapping(address => uint256) waveCount;
    constructor() payable {
        console.log("Yo yo, I am a contract and I am smart");
        /*
         * Set the initial seed
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "wait 30 seconds"
        );
         /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s waved w/ message %s", msg.sender, _message);

        waves.push(Wave(msg.sender, _message,block.timestamp));
        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = ( block.difficulty + block.timestamp + seed) % 100;

         console.log("random # generated: %d", seed);

         /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 _prizeAmount = 0.0001 ether;
            require(
                _prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool _success, ) = (msg.sender).call{value: _prizeAmount}("");
            require(_success, "Failed to withdraw money from contract.");

        }

        emit NewWave(msg.sender, block.timestamp, _message);

        uint256 prizeAmount = 0.0001 ether;
        require(
            prizeAmount <= address(this).balance,
            "trying to withdraw more money than the contract has."
        );
        (bool success,) = (msg.sender).call{value: prizeAmount}("");
        require(success, "failed to withdraw money from contract.");
    }
    /*
     * I added a function getAllWaves which will return the struct array, waves, to us.
     * This will make it easy to retrieve the waves from our website!
     */
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
    function getTotalWaves() public view returns(uint256){
        console.log("We have %d total waves!",totalWaves);
        return totalWaves;
    }
    function countWaves(address _whoWave) public {
        noOfWaves += 1;
        waveCount[_whoWave]=noOfWaves;
    }
    function viewCount(address _waveCount) public view returns(uint256){
        console.log(_waveCount,"has waved",waveCount[_waveCount],"times");
        return waveCount[_waveCount];
    }

}