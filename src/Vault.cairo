# Week 9 - Vault Contract Exercise
# Your vault contract must have the following functionality:

# Preamble
# --------
# tests/test_Vault.cairo is intended to be used for TDD
# use interfaces/IVault.cairo function signatures to get required functions and their signatures
# bonus exercises are available at the end of test_Vault.cairo under Bonus

# 1) Allow users to deposit your custom ERC20 token
# ---
# E.g. Alice deposits 5 ERC20 tokens into vault contract

# 2) Allow users to withdraw their deposited tokens
# ---
# E.g. Alice withdraws her deposited tokens, given that Alice has already staked

# 3) Allow users to transfer their staked tokens to another user
# ---
# E.g. Alice wants to transfer 5 of her staked tokens to another user of the Vault contract.
# Bob now has a staked vault balance of 5 tokens, and can withdraw them or transfer them

# 4) Keep track of the users' balances inside the staking contract
# ---
# E.g. Alice wants to know her staked balance inside the contract so that Alice may deposit more, withdraw or send tokens

# 5) Allow users to see the allowance allocated to the Vault contract for a user
# ---
# E.g. Alice wants to know the allowance the Vault contract has so she may know how many tokens she can deposit

# 6) Choose 2 or more appropriate places to place an event with the relevant information (not in TDD)
# ---
# Select appropriate on-chain data to capture externally. Give examples of which back-end systems could consume these events

%lang starknet

# Imports

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address
from starkware.cairo.common.uint256 import Uint256, uint256_le, uint256_sub, uint256_add
from src.interfaces.IERC20 import IERC20
from starkware.cairo.common.bool import TRUE, FALSE

# Events (@event)
#

#
# Storage (@storage_var)
#

#
# Constructor (@constructor)
#

#
# Getters (@views)
#

#
# Externals (@external)
#
