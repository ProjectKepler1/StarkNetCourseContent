// Week 8 - Faucet Contract Exercise
// Your faucet contract must have the following functionality:

// 1) Allow users to mint your custom ERC20 token from the faucet (external calls to ERC20 via interface)
// ---
// E.g. Alice interacts with Faucets contract to receive your ERC20 token so that Alice may trade your asset later

// 2) Allow users to retrieve the information about your ERC20 token
// ---
// E.g. Alice wants to know the name and symbol of your ERC20 token before using the faucet to verify it's the correct token

// 3) Allow users to retrieve the amount recieved from the faucet (the total sum of the amount minted from the faucet contract, not MyErC20Contract.balanceOf(user))
// ---
// E.g. Alice wants to know how much in total Alice has recieved from the faucet

// Use the interface to guide your development.
// Interface usage
// IERC20FAUCET.name(contract_address=your_deployed_erc20_address)

// Note: balances are treated as Uint256's to aid in EVM uint256 compatability. Standards will represent balances and token id's (to name some) as Uint256 in cairo.
// ---
// Felts only go up to 252-bit. To reach 256 bit, another felt is needed. Most cases we will only need 252 bits, so we can set the high as 0.
// Larger numbers than 252, overflow is needed in the high member.

// Represents an integer in the range [0, 2^256).
// struct Uint256:
//     The low 128 bits of the value.
//     member low : felt
//     The high 128 bits of the value.
//     member high : felt
// end

%lang starknet

// Imports

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_add
from starkware.starknet.common.syscalls import get_caller_address
from src.interfaces.IERC20Faucet import IERC20Faucet

//
// Storage (@storage_var)
//

//
// Constructor (@constructor)
//

//
// Getters (@views)
//

//
// Externals (@external)
//
