// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "interfaces/IBentoBoxV1.sol";
import "interfaces/IKashiPair.sol";



library KashiPairLib {

    function getKashiPairParameters(
        IERC20 collateral,
        IERC20 asset,
        IOracle oracle,
        bytes memory oracleData
    ) public pure returns (bytes memory) {
        return
            abi.encode(
                collateral,
                asset,
                oracle,
                oracleData
            );
    }

    function deployKashiPair(
        IBentoBoxV1 bentoBox,
        address masterContract,
        IERC20 collateral,
        IERC20 asset,
        IOracle oracle,
        bytes memory oracleData
    ) internal returns (IKashiPair pair){
        
        bytes memory data = getKashiPairParameters(collateral, asset, oracle, oracleData);
        return IKashiPair(IBentoBoxV1(bentoBox).deploy(masterContract, data, true));
    }
}