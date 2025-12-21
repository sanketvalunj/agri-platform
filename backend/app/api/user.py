from fastapi import APIRouter
from app.models.user_models import UserLocation
from app.services.user_service import save_user_location

router = APIRouter()

@router.post("/location")
def save_location(data: UserLocation):
    save_user_location(data.user_id, data.dict())
    return {"status": "location saved"}
