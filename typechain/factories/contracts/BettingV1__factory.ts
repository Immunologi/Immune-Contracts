/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../common";
import type { BettingV1, BettingV1Interface } from "../../contracts/BettingV1";

const _abi = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
];

const _bytecode =
  "0x6080604052348015600f57600080fd5b50603f80601d6000396000f3fe6080604052600080fdfea264697066735822122044bfc41a83d204fda68317892513cfebaf59a390754d2ded2bbfd30fa67a4b7c64736f6c63430008070033";

type BettingV1ConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: BettingV1ConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class BettingV1__factory extends ContractFactory {
  constructor(...args: BettingV1ConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<BettingV1> {
    return super.deploy(overrides || {}) as Promise<BettingV1>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): BettingV1 {
    return super.attach(address) as BettingV1;
  }
  override connect(signer: Signer): BettingV1__factory {
    return super.connect(signer) as BettingV1__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): BettingV1Interface {
    return new utils.Interface(_abi) as BettingV1Interface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): BettingV1 {
    return new Contract(address, _abi, signerOrProvider) as BettingV1;
  }
}
