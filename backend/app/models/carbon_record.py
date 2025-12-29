from sqlalchemy import Column, Float, DateTime, ForeignKey, JSON
from sqlalchemy.dialects.postgresql import UUID
from app.db.base import Base
import uuid
from datetime import datetime

class CarbonRecord(Base):
    __tablename__ = "carbon_records"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    farmer_id = Column(UUID(as_uuid=True), ForeignKey("farmers.id"), nullable=False)
    total_credits = Column(Float, nullable=False)
    confidence_score = Column(Float, nullable=False)  # 0-100
    breakdown = Column(JSON, nullable=False)  # {"trees": 0.6, "soil": 0.8, "fertilizer": 0.4}
    verified_actions = Column(JSON, nullable=False)  # {"tree_plantation": true, "drip_irrigation": true, ...}
    last_updated = Column(DateTime, default=datetime.utcnow)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
