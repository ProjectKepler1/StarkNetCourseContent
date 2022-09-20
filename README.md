# StarkNet Course Content

## Block 1

- [Exercise 1: Counter.cairo](src/Counter.cairo)
- [Exercise 2: Faucet.cairo](src/Faucet.cairo)
- [Exercise 3: Vault.cairo](src/Vault.cairo)

## Block 2

- [Exercise 4: Oracle.cairo](src/Oracle.cairo)
- [Exercise 5: Proxy.cairo](src/Proxy.cairo)

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

