# StarkNet Course Smart Contract Development Block

Exercise 1:
Counter.cairo 

Exercise 2:
Faucet.cairo

Exercise 3:
Vault.cairo

# Setup

There are two steps in the setup: _StarkNet_ and _Protostar_.

For _StarkNet_:

``` sh
python3.8 -m venv ~/cairo38_venv
source ~/cairo38_venv/bin/activate
pip install cairo-lang
```

And for _Protostar_:

https://docs.swmansion.com/protostar/docs/tutorials/installation

# Usage

Implement the exercises and execute tests:

``` sh
protostar test
```

or for a specific exercise:

``` sh
protostar test tests/test_Counter.cairo
```

