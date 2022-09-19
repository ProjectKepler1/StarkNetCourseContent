%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IVault {
    func get_erc20_address() -> (token_address: felt) {
    }

    func get_vault_allowance(user: felt) -> (allowance: Uint256) {
    }

    func get_staked_balance(user: felt) -> (amount: Uint256) {
    }

    func set_vault_allowance(amount: Uint256) -> () {
    }

    func deposit_token(amount: Uint256) -> () {
    }

    func withdraw_token(amount: Uint256) -> () {
    }

    func transfer_staked_tokens(amount: Uint256, to: felt) -> () {
    }
}
