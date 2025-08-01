# simple-erc20-token
Basic ERC-20 token implementation on Ethereum.

This project is a **Vyper smart contract** built using the **Ape Framework**.  
It implements a simple **ERC‑20 token** and a **crowdsale mechanism** that accepts ETH as payment for tokens.

## Features
- ERC‑20 compatible token
- Crowdsale with funding goal & deadline
- Accepts ETH for token purchase
- Refund contributors if funding goal not reached
- Beneficiary withdrawal if funding goal reached
- Written in **Vyper** for security and clarity

---

## 📦 Requirements

Make sure you have the following installed:

- [Python 3.10+](https://www.python.org/downloads/)
- [Ape Framework](https://docs.apeworx.io/ape/stable/userguides/quickstart.html)
- [Vyper compiler](https://docs.vyperlang.org/en/stable/installing-vyper.html)
- [Node.js & npm](https://nodejs.org/) (optional, for some tooling)

Install Ape and Vyper:

```bash
pip install eth-ape
ape plugins install vyper
````

---

## 🚀 Setup

1. **Clone the repository**

```bash
git https://github.com/zhnr01/simple-erc20-token
cd simple-erc20-token
```

2. **Create a Python virtual environment (recommended)**

```bash
python3 -m venv env
source env/bin/activate
```

3. **Install dependencies**

```bash
pip install -r requirements.txt
```

4. **Compile the contracts**

```bash
ape compile
```
---
## 📜 Deployment

You can deploy this contract to any EVM-compatible blockchain (Ethereum, Polygon, BSC, etc.)
using the Ape Framework or any other tool of your choice.


The CrowdSaleToken contract is deployed on the **Ethereum Sepolia Testnet**.

**Contract Address:** [`0xe1076a60c288D541Da9462a65e6F2E6Abfb37913`](https://sepolia.etherscan.io/address/0xe1076a60c288D541Da9462a65e6F2E6Abfb37913)

The erc20_token contract is also deployed on the **Ethereum Sepolia Testnet**.

**Contract Address:** [`0xBbF76A17b88014a0bF96e350AAFA3aC934C19CFf](https://sepolia.etherscan.io/address/0xBbF76A17b88014a0bF96e350AAFA3aC934C19CFf)

- **Network:** Ethereum Sepolia Testnet
- **Compiler:** Vyper
- **Deployment Tool:** Ape Framework + Alchemy

### 💬 Interacting with the Contract
You can interact with the deployed contract in several ways:
1. **Etherscan** – Use the "Write Contract" and "Read Contract" tabs on Etherscan after connecting your wallet.
1. **Ape Framework CLI** – Call contract functions using Ape scripts or console.
2. **Web3.py / ethers.js** – Integrate into your own frontend or Python scripts.
---

## 💰 Buying Tokens (Crowdsale)

Once deployed:

* Send ETH directly to the contract address **or**
* Call the `__default__()` function from Ape or your wallet.

---

## 🔄 Withdrawing / Refunding

* **Beneficiary** calls `safeWithdrawal()` if funding goal reached.
* **Contributors** call `safeWithdrawal()` if funding goal not reached to get their ETH back.

---

## ⚠️ Disclaimer

This contract is for **educational purposes only**.
Do **NOT** deploy it on mainnet without proper security audits.

---

