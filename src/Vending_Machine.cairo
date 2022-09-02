# Week 5 Vending Machine Example

# https://goerli.voyager.online/contract/0x01fd4feefb84cf4bc325160ed6bc8505618ed456884c6fe6cd0faaa760064fd0
# https://goerli.voyager.online/tx/0x76322907bb4c487337a543f3563c946a39e894be5ba0e9bf3a5258d36dd9186

# Declare this file as a StarkNet contract.
%lang starknet

# Import the HashBuiltin used for accessing storage variables via hash map
from starkware.cairo.common.cairo_builtins import HashBuiltin

# -----------------
#      Events
# -----------------
# Use events to capture information. We might need to update the item count on a FE
@event
func item_dispensed(item : felt, new_item_count : felt):
end

# -----------------
# Storage Variables
# -----------------
# Item Quantities
# ---
@storage_var
func skittles_sour_quantity() -> (count : felt):
end

@storage_var
func chips_qauntity() -> (count : felt):
end

# Item prices
# ---
@storage_var
func skittles_sour_price() -> (price : felt):
end

@storage_var
func chips_price() -> (price : felt):
end

# Token count
# ---
@storage_var
func user_tokens() -> (bal : felt):
end

# -----------------
#   Constructor
# -----------------
# Use constructor to initialize the initial item quantities and prices prior to usage
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _skittles_sour_quantity : felt,
    _chips_qauntity : felt,
    _skittles_sour_price : felt,
    _chips_price : felt,
    token_supply : felt,
):
    skittles_sour_quantity.write(_skittles_sour_quantity)
    chips_qauntity.write(_chips_qauntity)

    skittles_sour_price.write(_skittles_sour_price)
    chips_price.write(_chips_price)

    user_tokens.write(token_supply)

    return ()
end

# -----------------
#       View
# -----------------
# Read contract storage to retrieve item information (we are not modifying state)
# ---
@view
func get_skittle_info{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    quantity : felt, price : felt
):
    let (quantity) = skittles_sour_quantity.read()
    let (price) = skittles_sour_price.read()

    return (quantity, price)
end

@view
func get_chips_info{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    quantity : felt, price : felt
):
    let (quantity) = chips_qauntity.read()
    let (price) = chips_price.read()

    return (quantity, price)
end

@view
func get_tokens{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
    amount : felt
):
    let (remaining_amount) = user_tokens.read()

    return (remaining_amount)
end

# -----------------
#    Externals
# -----------------
# Now we are modifying state
@external
func vendor_skittles{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (skittles_price) = skittles_sour_price.read()
    let (skittles_quantity) = skittles_sour_quantity.read()
    let (user_balances) = user_tokens.read()

    # Remember tempvar allocated a single memory cell of name <x> and assigns it the value of the RHS expression
    tempvar new_quantity = skittles_quantity - 1
    tempvar new_balance = user_balances - skittles_price

    skittles_sour_quantity.write(new_quantity)
    user_tokens.write(new_balance)

    item_dispensed.emit('skittles', new_quantity)
    return ()
end

# Questions:
# ---
# 1. Explain how this could be extended for use of an external contract as a token
# 2. Explain where error handling around state management is required
