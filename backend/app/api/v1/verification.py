from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.db.dependencies import get_db
from app.schemas.verification import VerificationUpdate, VerificationResponse
from app.models.verification import Verification, VerificationStatus
from app.models.user_models import User
from app.services.verification_service import VerificationService
from app.core.security import get_current_user, require_admin

router = APIRouter()

@router.get("/pending", response_model=List[VerificationResponse])
async def get_pending_verifications(
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db)
):
    """Get pending verifications (Admin only)"""
    return VerificationService.get_pending_verifications(db)

@router.put("/{verification_id}", response_model=VerificationResponse)
async def update_verification(
    verification_id: str,
    request: VerificationUpdate,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db)
):
    """Update verification status (Admin only)"""
    try:
        status_enum = VerificationStatus(request.status)
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid status"
        )
    
    verification = VerificationService.update_verification_status(
        db, verification_id, status_enum, current_user.id, request.notes
    )
    
    return verification
