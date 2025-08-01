# @version ^0.3.0

from vyper.interfaces import ERC20
from vyper.interfaces import ERC20Detailed

implements: ERC20
implements: ERC20Detailed

# Events
event Transfer:
    sender: indexed(address)
    recipient: indexed(address)
    value: uint256

event Approval:
    owner: indexed(address)
    spender: indexed(address)
    value: uint256

# Storage variables
name: public(String[32])
symbol: public(String[32])
decimals: public(uint8)
balanceOf: public(HashMap[address, uint256])
allowance: public(HashMap[address, HashMap[address, uint256]])
totalSupply: public(uint256)
owner: public(address)

# Constructor
@external
def __init__(_name: String[32], _symbol: String[32], _decimals: uint8, _supply: uint256):
    init_supply: uint256 = _supply * 10 ** convert(_decimals, uint256)
    self.name = _name
    self.symbol = _symbol
    self.decimals = _decimals
    self.balanceOf[msg.sender] = init_supply
    self.totalSupply = init_supply
    self.owner = msg.sender
    log Transfer(empty(address), msg.sender, init_supply)

# ERC-20: transfer
@external
def transfer(_to: address, _value: uint256) -> bool:
    assert self.balanceOf[msg.sender] >= _value, "Insufficient balance"
    self.balanceOf[msg.sender] -= _value
    self.balanceOf[_to] += _value
    log Transfer(msg.sender, _to, _value)
    return True

# ERC-20: transferFrom
@external
def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
    assert self.balanceOf[_from] >= _value, "Insufficient balance"
    assert self.allowance[_from][msg.sender] >= _value, "Allowance exceeded"
    self.balanceOf[_from] -= _value
    self.balanceOf[_to] += _value
    self.allowance[_from][msg.sender] -= _value
    log Transfer(_from, _to, _value)
    return True

# ERC-20: approve
@external
def approve(_spender: address, _value: uint256) -> bool:
    self.allowance[msg.sender][_spender] = _value
    log Approval(msg.sender, _spender, _value)
    return True

# Mint new tokens
@external
def mint(_account: address, _amount: uint256) -> bool:
    assert msg.sender == self.owner, "Only owner can mint"
    self.balanceOf[_account] += _amount
    self.totalSupply += _amount
    log Transfer(empty(address), _account, _amount)
    return True

# Burn tokens
@external
def burn(_account: address, _amount: uint256) -> bool:
    assert self.balanceOf[_account] >= _amount, "Insufficient balance"
    self.balanceOf[_account] -= _amount
    self.totalSupply -= _amount
    log Transfer(_account, empty(address), _amount)
    return True
