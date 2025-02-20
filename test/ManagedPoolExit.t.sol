// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IVault} from "@balancer-v2-monorepo/interfaces/vault/IVault.sol";
import {IAsset} from "@balancer-v2-monorepo/interfaces/vault/IAsset.sol";

contract ManagedPoolExitTest is Test {
    function setUp() public {
        vm.createSelectFork("wss://base-rpc.publicnode.com");
    }

    function test_ManagedPoolExit() public {
        IVault vault = IVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
        bytes32 poolId = bytes32(0x545144e7e8171ba25ddda20eb6a726c4e7f4c623000100000000000000000170);
        address user = address(0xC0C7ec26cC1AA900a515e4BC993C714BAF0C58e9);

        IAsset[] memory assets = new IAsset[](3);
        assets[0] = IAsset(address(0x545144e7e8171BA25ddDa20eB6a726c4E7F4c623));
        assets[1] = IAsset(address(0xf39217e37aC27194A73E182A71548F9A481f93A6));
        assets[2] = IAsset(address(0xFa49888C3f547126335Ae05De79c7Fc1252198cf));

        uint256[] memory minAmountsOut = new uint256[](3);
        minAmountsOut[0] = 0;
        minAmountsOut[1] = 0;
        minAmountsOut[2] = 0;

        bytes memory userData = abi.encode(
            uint256(0), // exit kind
            uint256(1e16), // bpt amount
            uint256(0) // token index
        );

        bool toInternalBalance = false;

        IVault.ExitPoolRequest memory request =
            IVault.ExitPoolRequest(assets, minAmountsOut, userData, toInternalBalance);

        vm.startPrank(user);

        vault.exitPool(poolId, user, payable(user), request);

        vm.stopPrank();
    }
}
