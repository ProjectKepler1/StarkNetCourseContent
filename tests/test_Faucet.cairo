%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_add
from src.interfaces.IERC20Faucet import IERC20Faucet

const NAME = 'James Jumping Jacks';
const SYMBOL = 'JJJ';
const OWNER = 123456;
const DECIMALS = 18;
const CAP_LOW = 1000000;
const CAP_HIGH = 0;

@contract_interface
namespace IFaucet {
    func trigger_faucet(amount: Uint256) -> () {
    }

    func get_erc20_address() -> (token_address: felt) {
    }

    func get_token_name() -> (token_name: felt) {
    }

    func get_token_symbol() -> (token_symbol: felt) {
    }

    func get_faucet_amount(user: felt) -> (faucet_amount: Uint256) {
    }
}

@view
func __setup__() {
    %{
        context.contract_address_20 = deploy_contract("./src/ERC20/ERC20Faucet.cairo", 
            [
                ids.NAME, ids.SYMBOL, ids.DECIMALS, ids.OWNER, ids.CAP_LOW, ids.CAP_HIGH, 
            ]
        ).contract_address

        context.contract_address_faucet = deploy_contract("./src/Faucet.cairo", 
            [
                context.contract_address_20
            ]
        ).contract_address
    %}

    return ();
}

@view
func test_correct_token_fields{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local faucet_address;
    local erc20_address;

    %{ ids.faucet_address = context.contract_address_faucet %}
    %{ ids.erc20_address = context.contract_address_20 %}

    let (token_address) = IFaucet.get_erc20_address(faucet_address);
    let (token_name) = IFaucet.get_token_name(faucet_address);
    let (token_symbol) = IFaucet.get_token_symbol(faucet_address);

    let (expected_token_name) = IERC20Faucet.name(erc20_address);
    let (expected_token_symbol) = IERC20Faucet.symbol(erc20_address);

    assert token_address = erc20_address;
    assert token_name = expected_token_name;
    assert token_symbol = expected_token_symbol;

    return ();
}

@view
func test_faucet{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local faucet_address;

    %{ ids.faucet_address = context.contract_address_faucet %}

    let account_1 = 123;
    let amount = Uint256(100, 0);

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_faucet) %}
    IFaucet.trigger_faucet(faucet_address, amount);
    %{ stop_prank_callable() %}

    let (faucet_amount) = IFaucet.get_faucet_amount(faucet_address, account_1);
    assert faucet_amount = amount;

    return ();
}
