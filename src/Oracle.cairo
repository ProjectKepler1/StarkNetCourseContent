%lang starknet

from openzeppelin.access.ownable.library import Ownable

@event
func value_added(time: felt, value: felt) {
}

@storage_var
func timeseries(time: felt) -> (value: felt) {
}

@storage_var
func latest_time() -> (time: felt) {
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt) {
    Ownable.initialize(owner);

    return ();
}

@external
func ingest{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(time: felt, value: felt) {
    Ownable.assert_only_owner();

    timeseries.write(time, value);
    latest_time.write(time);

    value_added.emit(time, value);

    return ();
}

@view
func value_at{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(time: felt) -> (value: felt) {
    return timeseries.read(time);
}

@view
func latest_value{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (value: felt) {
    let (tip) = latest_time.read();

    return timeseries.read(tip);
}

// Interesting things that could be done:
//
// - multiple writers
// - signature verification
// - some form of input verficiation
