// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "utils/BaseTest.sol";
import "interfaces/IBentoBoxV1.sol";
import "interfaces/IKashiPair.sol";
import "pairs/KashiPair.sol";
import "utils/KashiPairLib.sol";
import "script/KashiPair.s.sol";


contract KashiPairTest is BaseTest {
    IBentoBoxV1 public bentoBox;
    IKashiPair public pair;
    KashiPair public masterContract;
    ERC20 public sushi;
    ERC20 public usdc;

    function setUp() public override {
        forkMainnet(15973087);
        super.setUp();

        KashiPairScript script = new KashiPairScript();
        script.setTesting(true);
        masterContract = script.run();

        bentoBox = IBentoBoxV1(constants.getAddress("mainnet.bentobox"));
        sushi = ERC20(constants.getAddress("mainnet.sushi"));
        usdc = ERC20(constants.getAddress("mainnet.usdc"));

        //todo: can throw this in the utils/KashiPairLib and compute on fly probably
        bytes memory sushiUsdcOracleData = abi.encode(
            constants.getAddress("mainnet.chainlink.usdc.eth"),
            constants.getAddress("mainnet.chainlink.sushi.eth"),
            1000000
        );

        vm.startPrank(bentoBox.owner());
        bentoBox.whitelistMasterContract(address(masterContract), true);
        pair = KashiPairLib.deployKashiPair(
            bentoBox,
            address(masterContract),
            sushi,
            usdc,
            IOracle(constants.getAddress("mainnet.oracle.chainlinkV2")),
            sushiUsdcOracleData
        );

        vm.stopPrank();

        address sushiWhale = 0xcBE6B83e77cdc011Cc18F6f0Df8444E5783ed982;
        vm.startPrank(sushiWhale);
        sushi.approve(address(bentoBox), type(uint256).max);
        bentoBox.deposit(address(sushi), sushiWhale, sushiWhale, 100 ether, 0);
        vm.stopPrank();
    }

    function testKashiPairDeployed() public {
        IERC20 asset = pair.asset();
        IERC20 collateral = pair.collateral();
        assertEq(address(asset), address(usdc));
        assertEq(address(collateral), address(sushi));
    } 

}