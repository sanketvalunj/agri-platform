from web3 import Web3
import json
from app.core.carbon_config import (
    PROVIDER_URL,
    CONTRACT_ADDRESS,
    ABI_PATH
)

class CarbonBlockchainService:
    def __init__(self):
        self.w3 = Web3(Web3.HTTPProvider(PROVIDER_URL))

        with open(ABI_PATH) as f:
            abi = json.load(f)["abi"]

        self.contract = self.w3.eth.contract(
            address=CONTRACT_ADDRESS,
            abi=abi
        )

    def issue_credit(self, farmer_address, amount, source, admin_key):
        account = self.w3.eth.account.from_key(admin_key)

        txn = self.contract.functions.issueCredit(
            farmer_address,
            amount,
            source
        ).build_transaction({
            "from": account.address,
            "nonce": self.w3.eth.get_transaction_count(account.address),
            "gas": 3000000,
            "gasPrice": self.w3.to_wei("1", "gwei"),
            "chainId": 31337   # ⭐ REQUIRED for Hardhat
        })

        signed_txn = self.w3.eth.account.sign_transaction(txn, admin_key)
        tx_hash = self.w3.eth.send_raw_transaction(signed_txn.raw_transaction)

        return tx_hash


    def get_credits(self, farmer_address):
        return self.contract.functions.getCredits(farmer_address).call()

