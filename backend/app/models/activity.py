from sqlalchemy import Column, String, Float, DateTime, ForeignKey, Boolean
from sqlalchemy.dialects.postgresql import UUID
from app.db.base import Base
import uuid
from datetime import datetime

class Activity(Base):
    __tablename__ = "activities"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    farmer_id = Column(UUID(as_uuid=True), ForeignKey("farmers.id"), nullable=False)
    activity_type = Column(String, nullable=False)  # e.g., 'tree_plantation', 'drip_irrigation', 'no_till', 'fertilizer_reduction'
    value = Column(Float, nullable=False)  # e.g., number of trees, percentage reduction
    verified = Column(Boolean, default=False)
    image_url = Column(String)  # for verification
    ndvi_score = Column(Float)  # satellite indicator
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
