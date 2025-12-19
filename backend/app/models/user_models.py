from typing import Optional
from pydantic import BaseModel


class UserLocation(BaseModel):
    user_id: str
    state: str
    district: str
    village: Optional[str] = None
    language: Optional[str] = "en"
