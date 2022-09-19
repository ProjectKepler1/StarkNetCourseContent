%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_add
from src.interfaces.IERC20Faucet import IERC20Faucet
from src.interfaces.IVault import IVault

const NAME = 'James Jumping Jacks';
const SYMBOL = 'JJJ';
const OWNER = 123456;
const DECIMALS = 18;
const CAP_LOW = 1000000;
const CAP_HIGH = 0;

@view
func __setup__() {
    %{
        context.contract_address_20 = deploy_contract("./src/ERC20/ERC20Faucet.cairo", 
            [
                ids.NAME, ids.SYMBOL, ids.DECIMALS, ids.OWNER, ids.CAP_LOW, ids.CAP_HIGH, 
            ]
        ).contract_address

        context.contract_address_vault = deploy_contract("./src/Vault.cairo", 
            [
                context.contract_address_20
            ]
        ).contract_address
    %}

    return ();
}

@view
func test_correct_intilization_storage_variables{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    local vault_address;
    local erc20_address;
    %{ ids.vault_address = context.contract_address_vault %}
    %{ ids.erc20_address = context.contract_address_20 %}

    let account_1 = 123;

    let (token_address) = IVault.get_erc20_address(vault_address);
    let (staked_balance) = IVault.get_staked_balance(vault_address, account_1);

    assert token_address = erc20_address;
    assert staked_balance = Uint256(0, 0);

    return ();
}

@view
func test_set_allowance_for_vault{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;
    local vault_address;
    %{ ids.vault_address = context.contract_address_vault %}

    let account_1 = 123;
    let amount = Uint256(1000, 0);

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_20) %}
    IVault.set_vault_allowance(vault_address, amount);
    %{ stop_prank_callable() %}

    let (vault_allowance) = IVault.get_vault_allowance(vault_address, account_1);

    assert vault_allowance = amount;

    return ();
}

@view
func test_deposit_tokens{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local vault_address;
    local erc20_address;
    %{ ids.vault_address = context.contract_address_vault %}
    %{ ids.erc20_address = context.contract_address_20 %}

    let account_1 = 123;
    let amount = Uint256(1000, 0);

    test_utils.mint_tokens(erc20_address, account_1, amount);

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_20) %}
    IVault.set_vault_allowance(vault_address, amount);
    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_vault) %}
    IVault.deposit_token(vault_address, amount);
    %{ stop_prank_callable() %}

    let (staked_amount) = IVault.get_staked_balance(vault_address, account_1);

    assert staked_amount = amount;

    return ();
}

@view
func test_withdraw_tokens{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local vault_address;
    local erc20_address;
    %{ ids.vault_address = context.contract_address_vault %}
    %{ ids.erc20_address = context.contract_address_20 %}

    let account_1 = 123;
    let amount = Uint256(1000, 0);

    test_utils.mint_tokens(erc20_address, account_1, amount);

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_20) %}
    IVault.set_vault_allowance(vault_address, amount);
    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_vault) %}
    IVault.deposit_token(vault_address, amount);
    %{ stop_prank_callable() %}

    let (staked_amount) = IVault.get_staked_balance(vault_address, account_1);

    assert staked_amount = amount;

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_vault) %}
    IVault.withdraw_token(vault_address, amount);
    %{ stop_prank_callable() %}

    let (staked_amount_withdraw) = IVault.get_staked_balance(vault_address, account_1);

    assert staked_amount_withdraw = Uint256(0, 0);

    return ();
}

@view
func test_transfer_tokens{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local vault_address;
    local erc20_address;
    %{ ids.vault_address = context.contract_address_vault %}
    %{ ids.erc20_address = context.contract_address_20 %}

    let account_1 = 123;
    let account_2 = 321;
    let amount = Uint256(1000, 0);

    test_utils.mint_tokens(erc20_address, account_1, amount);

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_20) %}
    IVault.set_vault_allowance(vault_address, amount);
    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_vault) %}
    IVault.deposit_token(vault_address, amount);
    %{ stop_prank_callable() %}

    let (staked_amount) = IVault.get_staked_balance(vault_address, account_1);

    assert staked_amount = amount;

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_vault) %}
    IVault.transfer_staked_tokens(vault_address, amount, account_2);
    %{ stop_prank_callable() %}

    let (staked_amount_account_1) = IVault.get_staked_balance(vault_address, account_1);
    let (staked_amount_account_2) = IVault.get_staked_balance(vault_address, account_2);

    assert staked_amount_account_1 = Uint256(0, 0);
    assert staked_amount_account_2 = amount;

    return ();
}

//
// [------------------ BONUS ------------------]
// -----
// Add assertion error handling to your contract

@view
func test_deposit_tokens_reverts_insufficient_allowance{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    local vault_address;
    local erc20_address;
    %{ ids.vault_address = context.contract_address_vault %}
    %{ ids.erc20_address = context.contract_address_20 %}

    let account_1 = 123;
    let amount = Uint256(1000, 0);

    test_utils.mint_tokens(erc20_address, account_1, amount);

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_vault) %}
    %{ expect_revert(error_message="Vault: insufficient allowance for Vault") %}
    IVault.deposit_token(vault_address, amount);
    %{ stop_prank_callable() %}

    return ();
}

@view
func test_withdraw_tokens_reverts_insufficient_staked_balance{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    local vault_address;
    local erc20_address;
    %{ ids.vault_address = context.contract_address_vault %}
    %{ ids.erc20_address = context.contract_address_20 %}

    let account_1 = 123;
    let account_2 = 321;
    let amount = Uint256(1000, 0);

    test_utils.mint_tokens(erc20_address, account_1, amount);

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_20) %}
    IVault.set_vault_allowance(vault_address, amount);
    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_vault) %}
    IVault.deposit_token(vault_address, amount);
    %{ stop_prank_callable() %}

    let (staked_amount) = IVault.get_staked_balance(vault_address, account_1);

    assert staked_amount = amount;

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_vault) %}
    IVault.transfer_staked_tokens(vault_address, amount, account_2);
    %{ stop_prank_callable() %}

    let (staked_amount_account_1) = IVault.get_staked_balance(vault_address, account_1);
    let (staked_amount_account_2) = IVault.get_staked_balance(vault_address, account_2);

    assert staked_amount_account_1 = Uint256(0, 0);
    assert staked_amount_account_2 = amount;

    return ();
}

@view
func test_transfer_token_reverts{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    ) {
    alloc_locals;
    local vault_address;
    local erc20_address;
    %{ ids.vault_address = context.contract_address_vault %}
    %{ ids.erc20_address = context.contract_address_20 %}

    let account_1 = 123;
    let account_0 = 0;
    let account_2 = 321;
    let amount = Uint256(1000, 0);

    test_utils.mint_tokens(erc20_address, account_1, amount);

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_20) %}
    IVault.set_vault_allowance(vault_address, amount);
    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_vault) %}
    IVault.deposit_token(vault_address, amount);
    %{ stop_prank_callable() %}

    let (staked_amount) = IVault.get_staked_balance(vault_address, account_1);

    assert staked_amount = amount;

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_vault) %}
    %{ expect_revert(error_message="Vault: transfer recipient must be non-zero address") %}
    IVault.transfer_staked_tokens(vault_address, amount, account_0);
    %{ stop_prank_callable() %}

    %{ stop_prank_callable = start_prank(ids.account_1, context.contract_address_vault) %}
    %{ expect_revert(error_message="Vault: insufficient staked balance") %}
    IVault.transfer_staked_tokens(vault_address, Uint256(2000, 0), account_2);
    %{ stop_prank_callable() %}

    return ();
}

namespace test_utils {
    func mint_tokens{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}(
        contract_address: felt, to: felt, amount: Uint256
    ) {
        alloc_locals;
        local account = to;
        %{ stop_prank_callable = start_prank(ids.account, context.contract_address_20) %}
        IERC20Faucet.faucet(contract_address, amount);
        %{ stop_prank_callable() %}
        return ();
    }
}
