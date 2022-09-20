%lang starknet

@view
func add(a: felt, b: felt) -> (sum: felt) {
    let sum = a + b;
    return (sum=sum);
}
