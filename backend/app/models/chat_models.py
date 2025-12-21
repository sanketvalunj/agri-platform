from typing import Optional
from pydantic import BaseModel

class ChatRequest(BaseModel):
    user_id: str
    message: str
    language: Optional[str] = "en"

class ChatResponse(BaseModel):
    reply: str
    confidence: Optional[float] = 0.85
