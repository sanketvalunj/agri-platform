from pydantic import BaseModel
from typing import Dict, Any
from datetime import datetime

class CarbonDashboardResponse(BaseModel):
    credits: float
    confidence: float
    breakdown: Dict[str, float]
    verified_actions: Dict[str, bool]
    last_updated: str

    class Config:
        from_attributes = True

class CarbonDashboardRequest(BaseModel):
    farm_id: str
