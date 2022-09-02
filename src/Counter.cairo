# Week 7 introduction
# Counter.cairo is an introduction smart contract that exposes primitives.
# Ensure you are able to deploy this contract to Georli testnet.
# Interact with the contract on Voyager.
# What is the exercise name as a string?
# Ensure the owner's hexadecimal representation is your account address
# Increment the counter via external function
# Verify the counter has been incremented

# Questions:
# 1) extend the counter storage variable to support multiple levels
# 2) extend the external functionality to decrement only if the current value is +ve non-zero, else revert. (https://perama-v.github.io/cairo/examples/assert/)

# Declare this file as a StarkNet contract.
%lang starknet

# Import the HashBuiltin used for accessing storage variables via hash map
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero

#
# Storage
#

# Exercise name
@storage_var
func exercise_name() -> (name : felt):
end

# Contract owner
@storage_var
func owner() -> (owner_address : felt):
end

# User balance
@storage_var
func counter() -> (res : felt):
end

#
# Constructor
#

# This will be only invoked once at the time of contract deployment
# Use utils.py file to convert your hex account address to a felt
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner_address : felt
):
    owner.write(owner_address)
    exercise_name.write(453786385260745320929924265796006757)
    return ()
end

#
# Getters
#

# Get the exercise name from storage
@view
func get_exercise_name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    name : felt
):
    let (name) = exercise_name.read()

    return (name)
end

# Get the owner's address from storage
@view
func get_owner{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    owner : felt
):
    let (name) = owner.read()

    return (name)
end

# Get the current counter value from storage
@view
func get_counter{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    counter : felt
):
    let (counter_value) = counter.read()

    return (counter_value)
end

#
# Externals
#

# Increment the counter storage variable
@external
func increment_counter{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (current_counter_value) = counter.read()
    let new_counter_value = current_counter_value + 1

    counter.write(new_counter_value)
    return ()
end
