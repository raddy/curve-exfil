import { ethers } from 'ethers'
import { BigNumber } from "ethers";

const CurveDataBatchRequest = require('../out/CurveDataBatchRequest.sol/CurveDataBatchRequest.json');

const provider = new ethers.providers.InfuraProvider()
const wallet = ethers.Wallet.createRandom().connect(provider)
const Factory = new ethers.ContractFactory(CurveDataBatchRequest.abi, CurveDataBatchRequest.bytecode, wallet)

interface SwapResult {
    jAmountOut: BigNumber;
    iAmountIn: BigNumber;
  }

const main = async () => {
    const poolAddress = '0x5a6A4D54456819380173272A5E8E9B9904BdF41B'; // MIM-USDC
    const i = 0; 
    const j = 2;
    const levels = [
        ethers.BigNumber.from('1000000000000000000000'),
        ethers.BigNumber.from('10000000000000000000000'),
        ethers.BigNumber.from('100000000000000000000000')
    ];

    const { data } = Factory.getDeployTransaction(poolAddress, i, j, levels);

    const retData = await provider.call({ data })
    const simplifiedTypes = [
        'tuple(uint256 jAmountOut, uint256 iAmountIn)[]',
        'uint256',
      ];
    const [swapResults, blockNumber] = ethers.utils.defaultAbiCoder.decode(simplifiedTypes, retData);
    swapResults.forEach((swapResult: SwapResult, index: number) => {
        console.log(`Swapping %s MIM yields %s USDC`, swapResult.iAmountIn.toString(), swapResult.jAmountOut.toString());
    });
}

main()