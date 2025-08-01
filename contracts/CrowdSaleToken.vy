# @version ^0.3.0

# --- Events ---
event Payment:
    buyer: indexed(address)
    value: uint256

event Refund:
    recipient: indexed(address)
    value: uint256

event Withdrawal:
    beneficiary: indexed(address)
    value: uint256

# --- Interfaces ---
interface ERC20:
    def transfer(_to: address, _value: uint256) -> bool: nonpayable

# --- Storage variables ---
owner: public(address)
token: public(address)  # ERC20 token contract address
beneficiary: public(address)

minFundingGoal: public(uint256)
maxFundingGoal: public(uint256)
amountRaised: public(uint256)
deadline: public(uint256)
price: public(uint256)  # Price of 1 token in wei

fundingGoalReached: public(bool)
crowdsaleClosed: public(bool)

ethBalances: public(HashMap[address, uint256])

# --- Constructor ---
@external
def __init__(
    _token: address,
    _beneficiary: address,
    _minGoalEth: uint256,
    _maxGoalEth: uint256,
    _durationDays: uint256,
    _priceWei: uint256
):
    self.owner = msg.sender
    self.token = _token
    self.beneficiary = _beneficiary

    self.minFundingGoal = _minGoalEth
    self.maxFundingGoal = _maxGoalEth
    self.deadline = block.timestamp + _durationDays * 86400
    self.price = _priceWei

    self.fundingGoalReached = False
    self.crowdsaleClosed = False

# --- Fallback: receive ETH and sell tokens ---
@external
@payable
def __default__():
    assert not self.crowdsaleClosed, "Crowdsale is closed"
    assert msg.sender != self.beneficiary, "Beneficiary cannot buy tokens"
    assert self.amountRaised + msg.value <= self.maxFundingGoal, "Exceeds max funding goal"
    assert msg.value >= as_wei_value(0.01, "ether"), "Minimum contribution is 0.01 ETH"

    self.ethBalances[msg.sender] += msg.value
    self.amountRaised += msg.value

    tokenAmount: uint256 = msg.value / self.price
    success: bool = ERC20(self.token).transfer(msg.sender, tokenAmount)
    assert success, "Token transfer failed"

    log Payment(msg.sender, msg.value)

# --- Check if goal reached ---
@external
def checkGoalReached():
    assert block.timestamp > self.deadline, "Crowdsale still active"

    if self.amountRaised >= self.minFundingGoal:
        self.fundingGoalReached = True

    self.crowdsaleClosed = True

# --- Safe withdrawal ---
@external
def safeWithdrawal():
    assert self.crowdsaleClosed, "Crowdsale not closed yet"

    # Case 1: Goal NOT reached → refund contributors
    if not self.fundingGoalReached:
        if self.ethBalances[msg.sender] > 0:
            amount: uint256 = self.ethBalances[msg.sender]
            self.ethBalances[msg.sender] = 0
            send(msg.sender, amount)
            log Refund(msg.sender, amount)

    # Case 2: Goal reached → beneficiary withdraws funds
    else:
        if msg.sender == self.beneficiary and self.amountRaised > 0:
            send(self.beneficiary, self.amountRaised)
            log Withdrawal(self.beneficiary, self.amountRaised)
            self.amountRaised = 0
