from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.db.dependencies import get_db
from app.schemas.activity import ActivityCreate, ActivityUpdate, ActivityResponse
from app.models.activity import Activity
from app.models.farmer import Farmer
from app.models.user_models import User
from app.services.audit_services import AuditService
from app.services.carbon_engine import CarbonEngine
from app.core.security import get_current_user

router = APIRouter()

@router.get("/", response_model=List[ActivityResponse])
async def get_activities(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get all activities for current farmer"""
    farmer = db.query(Farmer).filter(Farmer.user_id == current_user.id).first()
    if not farmer:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Farmer profile not found"
        )
    
    activities = db.query(Activity).filter(Activity.farmer_id == farmer.id).all()
    return activities

@router.post("/", response_model=ActivityResponse)
async def create_activity(
    request: ActivityCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Create new activity"""
    farmer = db.query(Farmer).filter(Farmer.user_id == current_user.id).first()
    if not farmer:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Farmer profile not found"
        )
    
    activity = Activity(
        farmer_id=farmer.id,
        **request.dict()
    )
    db.add(activity)
    db.commit()
    db.refresh(activity)
    
    # Trigger carbon calculation
    CarbonEngine.calculate_and_update_carbon_record(db, farmer.id)
    
    # Log audit
    AuditService.log_action(
        db, current_user.id, "CREATE", "activity", str(activity.id),
        new_values=request.dict()
    )
    
    return activity

@router.put("/{activity_id}", response_model=ActivityResponse)
async def update_activity(
    activity_id: str,
    request: ActivityUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Update activity"""
    farmer = db.query(Farmer).filter(Farmer.user_id == current_user.id).first()
    if not farmer:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Farmer profile not found"
        )
    
    activity = db.query(Activity).filter(
        Activity.id == activity_id,
        Activity.farmer_id == farmer.id
    ).first()
    
    if not activity:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Activity not found"
        )
    
    old_values = {
        "activity_type": activity.activity_type,
        "value": activity.value,
        "verified": activity.verified
    }
    
    for field, value in request.dict(exclude_unset=True).items():
        setattr(activity, field, value)
    
    db.commit()
    db.refresh(activity)
    
    # Recalculate carbon if activity changed
    CarbonEngine.calculate_and_update_carbon_record(db, farmer.id)
    
    # Log audit
    AuditService.log_action(
        db, current_user.id, "UPDATE", "activity", activity_id,
        old_values=old_values, new_values=request.dict(exclude_unset=True)
    )
    
    return activity

@router.delete("/{activity_id}")
async def delete_activity(
    activity_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Delete activity"""
    farmer = db.query(Farmer).filter(Farmer.user_id == current_user.id).first()
    if not farmer:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Farmer profile not found"
        )
    
    activity = db.query(Activity).filter(
        Activity.id == activity_id,
        Activity.farmer_id == farmer.id
    ).first()
    
    if not activity:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Activity not found"
        )
    
    db.delete(activity)
    db.commit()
    
    # Recalculate carbon
    CarbonEngine.calculate_and_update_carbon_record(db, farmer.id)
    
    # Log audit
    AuditService.log_action(
        db, current_user.id, "DELETE", "activity", activity_id,
        old_values={
            "activity_type": activity.activity_type,
            "value": activity.value
        }
    )
    
    return {"message": "Activity deleted successfully"}

@router.post("/{activity_id}/verify")
async def request_verification(
    activity_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Request verification for activity"""
    farmer = db.query(Farmer).filter(Farmer.user_id == current_user.id).first()
    if not farmer:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Farmer profile not found"
        )
    
    activity = db.query(Activity).filter(
        Activity.id == activity_id,
        Activity.farmer_id == farmer.id
    ).first()
    
    if not activity:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Activity not found"
        )
    
    # Create verification request (implement admin assignment logic)
    from app.services.verification_service import VerificationService
    verification = VerificationService.create_verification_request(
        db, activity_id, "admin_user_id"  # Replace with actual admin ID
    )
    
    return {"message": "Verification request submitted", "verification_id": verification.id}
