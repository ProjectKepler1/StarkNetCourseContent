%lang starknet

@view
func identity(element: felt) -> (element: felt) {
    return (element=element);
}
