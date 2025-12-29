from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class FarmerBase(BaseModel):
    farm_area: float = Field(..., description="Farm area in hectares", gt=0)
    crop_type: str = Field(..., description="Type of crop grown")
    location_lat: Optional[float] = Field(None, description="Latitude coordinate")
    location_lng: Optional[float] = Field(None, description="Longitude coordinate")

class FarmerCreate(FarmerBase):
    pass

class FarmerUpdate(BaseModel):
    farm_area: Optional[float] = Field(None, gt=0)
    crop_type: Optional[str] = None
    location_lat: Optional[float] = None
    location_lng: Optional[float] = None

class FarmerResponse(FarmerBase):
    id: str
    user_id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
