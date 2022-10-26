// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "BoringSolidity/interfaces/IERC20.sol";
import "solbase/tokens/ERC20/ERC20.sol";
import "utils/BaseTest.sol";
import "interfaces/IBentoBoxV1.sol";


contract HelloWorldBento is BaseTest {
    IBentoBoxV1 public bentoBox;
    ERC20 public sushi;

    function setUp() public override {
        forkMainnet(15831906);
        super.setUp();

        bentoBox = IBentoBoxV1(constants.getAddress("mainnet.bentobox"));
        sushi = ERC20(constants.getAddress("mainnet.sushi"));

        address sushiWhale = 0xcBE6B83e77cdc011Cc18F6f0Df8444E5783ed982;
        vm.startPrank(sushiWhale);
        sushi.approve(address(bentoBox), type(uint256).max);
        bentoBox.deposit(IERC20(address(sushi)), sushiWhale, sushiWhale, 100 ether, 0);
        vm.stopPrank();
    }

    function testHelloWorld() public {
        address sushiWhale = 0xcBE6B83e77cdc011Cc18F6f0Df8444E5783ed982;
        uint256 helloBalance = bentoBox.balanceOf(IERC20(address(sushi)), sushiWhale);
        assertEq(helloBalance, bentoBox.toShare(IERC20(address(sushi)), 100 ether, false));
    }
}