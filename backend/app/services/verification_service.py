from datetime import datetime
from sqlalchemy.orm import Session
from app.models.verification import Verification, VerificationStatus
from app.models.activity import Activity
from app.models.user_models import User

class VerificationService:
    @staticmethod
    def create_verification_request(
        db: Session, 
        activity_id: str, 
        verifier_id: str
    ) -> Verification:
        verification = Verification(
            activity_id=activity_id,
            verifier_id=verifier_id,
            status=VerificationStatus.PENDING
        )
        db.add(verification)
        db.commit()
        db.refresh(verification)
        return verification
    
    @staticmethod
    def update_verification_status(
        db: Session, 
        verification_id: str, 
        status: VerificationStatus, 
        verifier_id: str,
        notes: str = None
    ) -> Verification:
        verification = db.query(Verification).filter(
            Verification.id == verification_id
        ).first()
        
        if not verification:
            raise ValueError("Verification not found")
        
        verification.status = status
        verification.verifier_id = verifier_id
        if notes:
            verification.notes = notes
        
        if status == VerificationStatus.APPROVED:
            verification.verified_at = datetime.utcnow()
            # Update activity verification status
            activity = db.query(Activity).filter(
                Activity.id == verification.activity_id
            ).first()
            if activity:
                activity.verified = True
        
        db.commit()
        db.refresh(verification)
        return verification
    
    @staticmethod
    def get_pending_verifications(db: Session) -> list[Verification]:
        return db.query(Verification).filter(
            Verification.status == VerificationStatus.PENDING
        ).all()
