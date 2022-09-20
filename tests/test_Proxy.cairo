%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@contract_interface
namespace IIdentity {
    func identity(element: felt) -> (element: felt) {
    }
}

@contract_interface
namespace IProxy {
    func upgrade(hash: felt) -> () {
    }
}

@contract_interface
namespace IAdd {
    func add(a: felt, b: felt) -> (sum: felt) {
    }
}

@view
func __setup__() {
    %{
        context.owner = 1

        context.identity_class_hash = declare("./src/Identity.cairo").class_hash
        context.add_class_hash = declare("./src/Add.cairo").class_hash

        proxy_deployment = deploy_contract("./src/Proxy.cairo", [context.owner, context.identity_class_hash])
        context.proxy_address = proxy_deployment.contract_address
    %}

    return ();
}

@view
func test_proxied_function_from_owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local contract_address;
    %{ ids.contract_address = context.proxy_address %}

    %{ stop_prank = start_prank(context.owner) %}

    let original_felt = 230703119;
    let (resulting_felt) = IIdentity.identity(contract_address, original_felt);

    %{ stop_prank() %}

    assert original_felt = resulting_felt;

    return ();
}

@view
func test_proxied_function_from_nonowner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local contract_address;
    %{ ids.contract_address = context.proxy_address %}

    %{ stop_prank = start_prank(context.owner + 1) %}

    let original_felt = 230703119;
    let (resulting_felt) = IIdentity.identity(contract_address, original_felt);

    %{ stop_prank() %}

    assert original_felt = resulting_felt;

    return ();
}

@view
func test_upgrade_from_nonowner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local contract_address;
    %{ ids.contract_address = context.proxy_address %}

    %{ stop_prank = start_prank(context.owner + 1) %}

    %{ expect_revert(error_message="Ownable: caller is not the owner") %}
    IProxy.upgrade(contract_address, 1);

    %{ stop_prank() %}

    return ();
}

@view
func test_upgrade_from_owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    local contract_address;
    local add_class_hash;
    %{
        ids.contract_address = context.proxy_address
        ids.add_class_hash = context.add_class_hash
    %}

    %{ stop_prank = start_prank(context.owner, ids.contract_address) %}
    IProxy.upgrade(contract_address, add_class_hash);
    %{ stop_prank() %}

    let (sum) = IAdd.add(contract_address, 2, 3);
    assert sum = 5;

    return ();
}
