%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@contract_interface
namespace IOracle {
    func ingest(value: felt) {
    }

    func latest_value() -> (value: felt)  {
    }

    func value_at(time: felt) -> (value: felt) {
    }
}

@view
func __setup__() {
    %{
        context.owner = 1

        deployment = deploy_contract("./src/Oracle.solution.cairo", [context.owner])
        context.contract_address = deployment.contract_address
    %}

    return ();
}

@view
func test_ingest_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local contract_address;

    %{
        ids.contract_address = context.contract_address
        stop_prank = start_prank(context.owner, context.contract_address)
        stop_roll = roll(1, context.contract_address)
    %}

    IOracle.ingest(contract_address, 1);

    let (latest_value) = IOracle.latest_value(contract_address);
    assert latest_value = 1;

    %{
        stop_prank()
        stop_roll()
    %}

    return ();
}

@view
func test_ingest_values{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local contract_address;
    %{
        ids.contract_address = context.contract_address
        stop_prank = start_prank(context.owner, context.contract_address)
    %}

    %{ stop_roll = roll(1, context.contract_address) %}
    IOracle.ingest(contract_address, 1);
    %{ stop_roll() %}

    %{ stop_roll = roll(2, context.contract_address) %}
    IOracle.ingest(contract_address, 2);
    %{ stop_roll() %}

    let (latest_value) = IOracle.latest_value(contract_address);
    assert latest_value = 2;

    let (previous_value) = IOracle.value_at(contract_address, 1);
    assert previous_value = 1;

    %{ stop_prank() %}

    return ();
}
