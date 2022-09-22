// StarkNet Oracle
//
// Use the block number as a timestamp for the timeseries.
//
// https://starknet.io/docs/hello_starknet/more_features.html#block-number-and-timestamp

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_block_number
from starkware.cairo.common.math import assert_lt, unsigned_div_rem
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
    Ownable.initializer(owner);

    return ();
}

func _process_value{range_check_ptr}(original: felt) -> (processed: felt) {
    let (quotient, _) = unsigned_div_rem(original, 100);

    if (quotient == 0) {
        return (processed=original);
    }

    return (processed=100);
}

@external
func ingest{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(value: felt) {
    Ownable.assert_only_owner();

    let (tip) = latest_time.read();
    let (time) = get_block_number();

    with_attr error_message("Value already ingested at current block") {
        assert_lt(tip, time);
    }

    let (processed_value) = _process_value(value);
    timeseries.write(time, processed_value);
    latest_time.write(time);

    value_added.emit(time, processed_value);

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
