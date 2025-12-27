from sqlalchemy import Column, String, DateTime
from app.db.base import Base
from datetime import datetime

class OTP(Base):
    __tablename__ = "otps"

    phone = Column(String, primary_key=True)
    otp = Column(String, nullable=False)
    expires_at = Column(DateTime, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
