from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime

class UserResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    phone: str
    role: str
    created_at: datetime
    updated_at: datetime

class UserLocationCreate(BaseModel):
    user_id: str
    latitude: float
    longitude: float
    city: str
