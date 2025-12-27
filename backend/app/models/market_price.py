# app/models/market_price.py
from sqlalchemy import Column, String, Float, Date
from sqlalchemy.dialects.postgresql import UUID
from app.db.database import Base
import uuid

class MarketPrice(Base):
    __tablename__ = "market_prices"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    commodity = Column(String, nullable=False)
    state = Column(String, nullable=False)
    mandi = Column(String, nullable=False)

    min_price = Column(Float, nullable=False)
    max_price = Column(Float, nullable=False)
    modal_price = Column(Float, nullable=False)

    arrival_date = Column(Date, nullable=False)
