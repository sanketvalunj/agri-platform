from sqlalchemy import Column, Integer, String, DateTime, Text
from sqlalchemy.sql import func
from app.db.base import Base

class AuditLog(Base):
    __tablename__ = "audit_logs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, nullable=False, index=True)
    action = Column(String, nullable=False)  # e.g., 'CREATE', 'UPDATE', 'DELETE'
    resource_type = Column(String, nullable=False)  # e.g., 'farmer', 'activity'
    resource_id = Column(String, nullable=False)
    old_values = Column(Text, nullable=True)  # JSON string
    new_values = Column(Text, nullable=True)  # JSON string
    created_at = Column(DateTime(timezone=True), server_default=func.now())
