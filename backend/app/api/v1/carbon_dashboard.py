from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.dependencies import get_db
from app.schemas.dashboard import CarbonDashboardResponse, CarbonDashboardRequest
from app.services.carbon_engine import CarbonEngine
from app.services.confidence_engine import ConfidenceEngine
from app.models.farmer import Farmer
from app.models.activity import Activity
from app.models.carbon_record import CarbonRecord
from typing import List
import uuid
from datetime import datetime

router = APIRouter()
carbon_engine = CarbonEngine()
confidence_engine = ConfidenceEngine()

@router.get("/dashboard", response_model=CarbonDashboardResponse)
def get_carbon_dashboard(farm_id: str, db: Session = Depends(get_db)):
    """
    Get carbon credit dashboard for a farmer.

    Query parameter: farm_id (UUID string)
    """
    try:
        farmer_id = uuid.UUID(farm_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid farm_id format")

    # Get farmer
    farmer = db.query(Farmer).filter(Farmer.id == farmer_id).first()
    if not farmer:
        raise HTTPException(status_code=404, detail="Farmer not found")

    # Get activities
    activities = db.query(Activity).filter(Activity.farmer_id == farmer_id).all()

    # Calculate carbon credits
    carbon_breakdown = carbon_engine.calculate_carbon_credits(activities)

    # Calculate confidence score
    confidence_score = confidence_engine.calculate_confidence_score(activities, farmer)

    # Determine verified actions
    verified_actions = {
        "tree_plantation": any(a.activity_type == "tree_plantation" and a.verified for a in activities),
        "drip_irrigation": any(a.activity_type == "drip_irrigation" and a.verified for a in activities),
        "no_till": any(a.activity_type == "no_till" and a.verified for a in activities),
    }

    # Get last updated from latest carbon record or current time
    last_record = db.query(CarbonRecord).filter(CarbonRecord.farmer_id == farmer_id).order_by(CarbonRecord.last_updated.desc()).first()
    last_updated = last_record.last_updated if last_record else datetime.utcnow()

    # Save or update carbon record
    total_credits = sum(carbon_breakdown.values())
    carbon_record = CarbonRecord(
        farmer_id=farmer_id,
        total_credits=total_credits,
        confidence_score=confidence_score,
        breakdown=carbon_breakdown,
        verified_actions=verified_actions,
        last_updated=datetime.utcnow()
    )
    db.add(carbon_record)
    db.commit()

    return CarbonDashboardResponse(
        credits=round(total_credits, 2),
        confidence=round(confidence_score, 2),
        breakdown={k: round(v, 2) for k, v in carbon_breakdown.items()},
        verified_actions=verified_actions,
        last_updated=last_updated.strftime("%Y-%m-%d")
    )
