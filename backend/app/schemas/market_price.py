from pydantic import BaseModel
from datetime import date

class MarketPriceResponse(BaseModel):
    commodity: str
    state: str
    mandi: str
    min_price: float
    max_price: float
    modal_price: float
    arrival_date: date

    class Config:
        orm_mode = True
