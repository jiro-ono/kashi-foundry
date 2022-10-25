// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol"
import "utils/BaseScript.sol";

contract MyScript is BaseScript {
    function run() public returns (uint256) {
        //setup

        vm.startBroadcast();

        // deployment example

        vm.stopBroadcast();

        return 0;
    }
}