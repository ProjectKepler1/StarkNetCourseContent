// Proxying with a custom implementation
//
// This example proxies a single contract wihout upgradeability. For real world
// usage with OpenZeppelin proxy contracts, check:
//
// https://docs.openzeppelin.com/contracts-cairo/0.4.0b/proxies
//
// Be mindful that StarkNet has a different approach to contracts than Ethereum:
// in StarkNet, the code of the contract is stored as a "contract class" and a
// specific deployed address is stored as a "contract instance". Contract
// classes have no state, only the code. Instances have state. For more
// information, check:
//
// https://starknet.io/docs/hello_starknet/intro.html#declare-the-contract-on-the-starknet-testnet
//
// Assignment:
//
// 1. Add ownership to this contract, making sure the owner passed in the
//    constructor is stored (use OpenZeppelin).
// 2. Add upgradeability to this contract, making sure only the owner can change
//    the implementation contract.
//
// Make sure all tests pass:
//
// (cairo38_venv) ❯ protostar test tests/test_Proxy.cairo

%lang starknet

// "Runs an entry point of another contract class on the current contract state"
//
// https://github.com/starkware-libs/cairo-lang/blob/54d7e92a703b3b5a1e07e9389608178129946efc/src/starkware/starknet/common/syscalls.cairo#L84
from starkware.starknet.common.syscalls import library_call
from starkware.cairo.common.cairo_builtins import HashBuiltin

// Store the `class_hash` of the implementation so we can call it later
@storage_var
func implementation_class_hash() -> (class_hash: felt) {
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt, hash: felt) {
    implementation_class_hash.write(hash);

    // TODO(assignment): ownership

    return ();
}

// Update the implementation class to a new one, but only if the caller is the
// owner.
@external
func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(hash: felt) {
    // TODO(assignment): upgrade and ownership check
    return ();
}

// __default__ gets called when no matching selector is found. In other words,
// when the function name being called in this contract does not exist.
//
// @raw_input: Do not decode the call data into arguments, passing it instead as
// (length, data).
//
// @raw_output: Encode the return value as "calldata" (actually retdata). The
// function must then return (length, data)
@external
@raw_input
@raw_output
func __default__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (
    selector: felt,
    calldata_size: felt,
    calldata: felt*
) -> (retdata_size: felt, retdata: felt*) {
    let (class_hash) = implementation_class_hash.read();

    // Call the implementation
    let retdata = library_call(class_hash, selector, calldata_size, calldata);

    return retdata;
}
