// StarkNet Oracle
//
// Use the block number as a timestamp for the timeseries.
//
// https://starknet.io/docs/hello_starknet/more_features.html#block-number-and-timestamp

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

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
    // TODO(assignment): initialize ownership

    return ();
}

@external
func ingest{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(value: felt) {
    // TODO(assignment): check ownership
    // TODO(assignment): get block number
    // TODO(assignment): check if there's already a value set for this block
    // TODO(assignment): bind the value within the range 0, 100
    // TODO(assignment): write to the timeseries
    // TODO(assignment): emit the `value_added` event

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
