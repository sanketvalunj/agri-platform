from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class ActivityBase(BaseModel):
    activity_type: str = Field(..., description="Type of activity (tree_plantation, drip_irrigation, etc.)")
    value: float = Field(..., description="Value associated with activity", gt=0)

class ActivityCreate(ActivityBase):
    pass

class ActivityUpdate(BaseModel):
    activity_type: Optional[str] = None
    value: Optional[float] = Field(None, gt=0)
    verified: Optional[bool] = None

class ActivityResponse(ActivityBase):
    id: str
    farmer_id: str
    verified: bool
    image_url: Optional[str]
    ndvi_score: Optional[float]
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
