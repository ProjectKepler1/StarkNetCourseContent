%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IVault:
    func get_erc20_address() -> (token_address : felt):
    end

    func get_vault_allowance(user : felt) -> (allowance : Uint256):
    end

    func get_staked_balance(user : felt) -> (amount : Uint256):
    end

    func set_vault_allowance(amount : Uint256) -> ():
    end

    func deposit_token(amount : Uint256) -> ():
    end

    func withdraw_token(amount : Uint256) -> ():
    end

    func transfer_staked_tokens(amount : Uint256, to : felt) -> ():
    end
end
