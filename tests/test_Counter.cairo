%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@contract_interface
namespace ICounter {
    func get_exercise_name() -> (name: felt) {
    }

    func get_owner() -> (owner: felt) {
    }

    func get_counter(level: felt) -> (counter: felt) {
    }

    func increment_counter(level: felt) -> () {
    }

    func decrement_counter(level: felt) -> () {
    }
}

const OWNER = 123;

@view
func __setup__() {
    %{
        context.contract_address = deploy_contract("./src/Counter.cairo", 
            [
                ids.OWNER
            ]
        ).contract_address
    %}

    return ();
}

@view
func test_get_exercise_name_get_owner_get_default_counter_value{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    local contract_address;

    %{ ids.contract_address = context.contract_address %}

    let (exercise_name) = ICounter.get_exercise_name(contract_address);
    let (owner) = ICounter.get_owner(contract_address);
    let level = 0;
    let (counter) = ICounter.get_counter(contract_address, level);

    let expected_name = 453786385260759488029372874731647845;
    let expected_owner = 123;

    assert exercise_name = expected_name;
    assert owner = expected_owner;
    assert counter = 0;
    return ();
}

@view
func test_increment_counter_different_levels{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    local contract_address;

    %{ ids.contract_address = context.contract_address %}

    let level_zero = 0;
    let level_one = 1;

    %{ stop_prank_callable = start_prank(context.contract_address) %}
    ICounter.increment_counter(contract_address, level_zero);
    ICounter.increment_counter(contract_address, level_zero);
    ICounter.increment_counter(contract_address, level_one);
    %{ stop_prank_callable() %}

    let (level_zero_counter) = ICounter.get_counter(contract_address, level_zero);
    let (level_one_counter) = ICounter.get_counter(contract_address, level_one);

    let expected_level_zero = 2;

    assert level_zero_counter = expected_level_zero;
    assert level_one_counter = level_one;

    return ();
}

@view
func test_decrement_counter_different_levels{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    local contract_address;

    %{ ids.contract_address = context.contract_address %}

    let level_zero = 0;
    let level_one = 1;

    %{ stop_prank_callable = start_prank(context.contract_address) %}
    ICounter.increment_counter(contract_address, level_zero);
    ICounter.increment_counter(contract_address, level_zero);
    ICounter.increment_counter(contract_address, level_one);

    ICounter.decrement_counter(contract_address, level_zero);
    ICounter.decrement_counter(contract_address, level_one);
    %{ stop_prank_callable() %}

    let (level_zero_counter) = ICounter.get_counter(contract_address, level_zero);
    let (level_one_counter) = ICounter.get_counter(contract_address, level_one);

    assert level_zero_counter = level_one;
    assert level_one_counter = level_zero;

    return ();
}

@view
func test_decrement_will_revert_with_zero_value{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr
}() {
    alloc_locals;
    local contract_address;

    %{ ids.contract_address = context.contract_address %}

    let level_zero = 0;
    let level_one = 1;

    %{ stop_prank_callable = start_prank(context.contract_address) %}
    %{ expect_revert(error_message="Counter: can only decremement values > 0") %}
    ICounter.decrement_counter(contract_address, level_zero);
    %{ stop_prank_callable() %}

    return ();
}
