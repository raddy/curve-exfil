// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interface/ICurveRegistryAddressProvider.sol";
import "./interface/ICurveMetaRegistry.sol";
import "./interface/ICurvePool.sol";
import "forge-std/console.sol";

contract CurveDataBatchRequest {
    address constant CURVE_ADDRESS_PROVIDER_ADDRESS = 0x0000000022D53366457F9d5E68Ec105046FC4383;
    uint256 constant META_REGISTRY_INDEX = 7;

    struct CurveSwapResult {
        uint256 jAmountOut;
        uint256 iAmountIn;
    }

    constructor(address pool, int128 i, int128 j, uint256[] memory levels) {
        CurveSwapResult[] memory swapResults = new CurveSwapResult[](levels.length);

        for (uint k = 0; k < levels.length; k++) {
            swapResults[k].iAmountIn = levels[k];
            swapResults[k].jAmountOut = getAmountOut(pool, i, j, levels[k]);
            console.log(levels[k]);
            console.log(swapResults[k].jAmountOut);
        }

        bytes memory abiEncodedData = abi.encode(swapResults, block.number);
        assembly {
            // Return from the start of the data (discarding the original data address)
            // up to the end of the memory used
            let dataStart := add(abiEncodedData, 0x20)
            return(dataStart, sub(msize(), dataStart))
        }
    }

    function getAmountOut(
        address pool,
        int128 i,
        int128 j,
        uint256 iQty
    ) public view returns (uint256 jAmountOut) {
        ICurveMetaRegistry metaRegistry = getCurveMetaRegistry();
        ICurvePool curvePool = ICurvePool(pool);
        if (metaRegistry.is_meta(pool)) {
            return curvePool.get_dy_underlying(i, j, iQty);
        } else {
            return curvePool.get_dy(i, j, iQty);
        }
    }

    function getCurveMetaRegistry() public view returns (ICurveMetaRegistry curveMetaRegistry) {
        ICurveRegistryAddressProvider registryAddressProvider = ICurveRegistryAddressProvider(CURVE_ADDRESS_PROVIDER_ADDRESS);
        (
            address metaRegistryAddress,
            bool active,
            ,
            ,

        ) = registryAddressProvider.get_id_info(META_REGISTRY_INDEX);
        if (!active) {
            revert("CRV Meta Registry Index is not active");
        }
        return ICurveMetaRegistry(metaRegistryAddress);
    }
}
