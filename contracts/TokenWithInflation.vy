# @version ^0.3.0

balances: public(HashMap[address, uint256])
owner: public(address)
total_supply: public(uint256)

@external
def __init__():
    self.balances[msg.sender] = 10000
    self.total_supply = 10000
    self.owner = msg.sender

@external
def transfer(_to: address, _amount: uint256) -> bool:
    assert self.balances[msg.sender] >= _amount, "Insufficient balance"
    self.balances[msg.sender] -= _amount
    self.balances[_to] += _amount
    return True

@external
def mint(_new_supply: uint256):
    assert msg.sender == self.owner, "Only owner can mint"
    self.balances[self.owner] += _new_supply
    self.total_supply += _new_supply
