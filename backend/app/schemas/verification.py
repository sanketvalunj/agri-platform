from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class VerificationBase(BaseModel):
    status: str = Field(..., description="Verification status")
    notes: Optional[str] = Field(None, description="Verification notes")

class VerificationCreate(VerificationBase):
    pass

class VerificationUpdate(BaseModel):
    status: Optional[str] = None
    notes: Optional[str] = None

class VerificationResponse(VerificationBase):
    id: str
    activity_id: str
    verifier_id: str
    verified_at: Optional[datetime]
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
