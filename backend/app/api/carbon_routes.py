from fastapi import APIRouter
from app.services.carbon_blockchain_service import CarbonBlockchainService

router = APIRouter()
service = CarbonBlockchainService()

@router.post("/issue")
def issue_credit(data: dict):
    tx = service.issue_credit(
        data["farmer_address"],
        data["amount"],
        data["source"],
        data["admin_key"]
    )
    return {"transaction_hash": tx.hex()}

@router.get("/credits/{farmer_address}")
def get_credits(farmer_address: str):
    return service.get_credits(farmer_address)
