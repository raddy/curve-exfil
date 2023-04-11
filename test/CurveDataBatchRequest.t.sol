// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/CurveDataBatchRequest.sol";

contract GasTest is DSTest {
    function setUp() public {}

    // helpful to remember that its just the layout you need
    struct PairResult {
        uint256 output;
        uint256 input;
    }

    function testBatchContract() public {
        address pool = 0x5a6A4D54456819380173272A5E8E9B9904BdF41B; // MIM-USDC
        int128 i = 0;
        int128 j = 2;

        uint256[] memory levels = new uint256[](3);
        levels[0] = 1e18 * 1000;
        levels[1] = 1e18 * 10000;
        levels[2] = 1e18 * 100000;

        CurveDataBatchRequest batchContract = new CurveDataBatchRequest(pool, i, j, levels);
        console.logBytes(address(batchContract).code);
        
        (PairResult[] memory swapResults, uint256 blockNumber) = abi.decode(address(batchContract).code, (PairResult[], uint256));
        for (uint k = 0; k < swapResults.length; ++k)
        {
            console.log("Swapping %s MIM yields %s USDC", swapResults[k].input, swapResults[k].output);
        }
    }
}
