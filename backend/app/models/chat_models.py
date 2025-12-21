from typing import Optional
from pydantic import BaseModel


class SoilInput(BaseModel):
    nitrogen: Optional[float] = None
    phosphorus: Optional[float] = None
    potassium: Optional[float] = None
    ph: Optional[float] = None


class ChatRequest(BaseModel):
    user_id: str
    message: str
    language: Optional[str] = "en"

    # Optional (farmer usually won't fill this)
    soil_data: Optional[SoilInput] = None
    district: Optional[str] = None


class ChatResponse(BaseModel):
    reply: str
    confidence: Optional[float] = 0.85
