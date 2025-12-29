from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.db.dependencies import get_db
from app.schemas.farmer import FarmerCreate, FarmerUpdate, FarmerResponse
from app.models.farmer import Farmer
from app.models.user_models import User
from app.services.audit_services import AuditService
from app.core.security import get_current_user

router = APIRouter()

@router.get("/profile", response_model=FarmerResponse)
async def get_farmer_profile(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get farmer profile"""
    farmer = db.query(Farmer).filter(Farmer.user_id == current_user.id).first()
    if not farmer:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Farmer profile not found"
        )
    return farmer

@router.put("/profile", response_model=FarmerResponse)
async def update_farmer_profile(
    request: FarmerUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Update farmer profile"""
    farmer = db.query(Farmer).filter(Farmer.user_id == current_user.id).first()
    if not farmer:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Farmer profile not found"
        )
    
    # Log audit
    old_values = {
        "farm_area": farmer.farm_area,
        "crop_type": farmer.crop_type,
        "location_lat": farmer.location_lat,
        "location_lng": farmer.location_lng
    }
    
    for field, value in request.dict(exclude_unset=True).items():
        setattr(farmer, field, value)
    
    db.commit()
    db.refresh(farmer)
    
    # Log audit
    AuditService.log_action(
        db, current_user.id, "UPDATE", "farmer", str(farmer.id),
        old_values=old_values, new_values=request.dict(exclude_unset=True)
    )
    
    return farmer

@router.post("/setup", response_model=FarmerResponse)
async def setup_farmer_profile(
    request: FarmerCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Setup farmer profile"""
    existing_farmer = db.query(Farmer).filter(Farmer.user_id == current_user.id).first()
    if existing_farmer:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Farmer profile already exists"
        )
    
    farmer = Farmer(
        user_id=current_user.id,
        **request.dict()
    )
    db.add(farmer)
    db.commit()
    db.refresh(farmer)
    
    # Log audit
    AuditService.log_action(
        db, current_user.id, "CREATE", "farmer", str(farmer.id),
        new_values=request.dict()
    )
    
    return farmer
