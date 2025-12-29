from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.db.dependencies import get_db
from app.schemas.carbon import CarbonCalculationRequest, CarbonCalculationResponse, CarbonRecordResponse
from app.models.carbon_record import CarbonRecord
from app.models.farmer import Farmer
from app.models.user_models import User
from app.services.carbon_engine import CarbonEngine
from app.core.security import get_current_user

router = APIRouter()

@router.post("/calculate", response_model=CarbonCalculationResponse)
async def calculate_carbon(
    request: CarbonCalculationRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Calculate carbon impact for an activity"""
    farmer = db.query(Farmer).filter(Farmer.user_id == current_user.id).first()
    if not farmer:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Farmer profile not found"
        )
    
    result = CarbonEngine.calculate_carbon_impact(
        request.activity_type, 
        request.value,
        farmer.id
    )
    
    return CarbonCalculationResponse(
        estimated_credits=result["credits"],
        confidence_score=result["confidence"],
        breakdown=result["breakdown"]
    )

@router.get("/dashboard", response_model=CarbonRecordResponse)
async def get_carbon_dashboard(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get carbon dashboard data"""
    farmer = db.query(Farmer).filter(Farmer.user_id == current_user.id).first()
    if not farmer:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Farmer profile not found"
        )
    
    carbon_record = db.query(CarbonRecord).filter(
        CarbonRecord.farmer_id == farmer.id
    ).first()
    
    if not carbon_record:
        # Create initial carbon record
        carbon_record = CarbonEngine.calculate_and_update_carbon_record(db, farmer.id)
    
    return carbon_record

@router.get("/history", response_model=List[CarbonRecordResponse])
async def get_carbon_history(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get carbon history"""
    farmer = db.query(Farmer).filter(Farmer.user_id == current_user.id).first()
    if not farmer:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Farmer profile not found"
        )
    
    records = db.query(CarbonRecord).filter(
        CarbonRecord.farmer_id == farmer.id
    ).order_by(CarbonRecord.created_at.desc()).all()
    
    return records
