import secrets
from datetime import datetime, timedelta
from typing import Optional
from jose import jwt
from sqlalchemy.orm import Session
from app.core.config import settings
from app.models.user_models import User
from app.utils.sms import send_otp_sms

class AuthService:
    @staticmethod
    def generate_session_id() -> str:
        return secrets.token_url_safe(32)
    
    @staticmethod
    def generate_otp() -> str:
        return str(secrets.randbelow(900000) + 100000)
    
    @staticmethod
    async def send_login_otp(phone: str) -> tuple[bool, str]:
        """Send OTP to phone number and return session_id"""
        session_id = AuthService.generate_session_id()
        otp = AuthService.generate_otp()
        
        # Store OTP in cache/session store (implement as needed)
        # For now, just simulate sending
        success = send_otp_sms(phone, f"Your OTP is: {otp}")
        
        return success, session_id
    
    @staticmethod
    def verify_otp(session_id: str, otp: str) -> bool:
        """Verify OTP (implement cache check)"""
        # Implement OTP verification logic
        return True  # Placeholder
    
    @staticmethod
    def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
        to_encode = data.copy()
        if expires_delta:
            expire = datetime.utcnow() + expires_delta
        else:
            expire = datetime.utcnow() + timedelta(minutes=15)
        to_encode.update({"exp": expire})
        encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
        return encoded_jwt
    
    @staticmethod
    def create_refresh_token(data: dict):
        to_encode = data.copy()
        expire = datetime.utcnow() + timedelta(days=7)
        to_encode.update({"exp": expire, "type": "refresh"})
        encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
        return encoded_jwt
    
    @staticmethod
    def get_user_by_phone(db: Session, phone: str) -> Optional[User]:
        return db.query(User).filter(User.phone == phone).first()
    
    @staticmethod
    def create_user(db: Session, phone: str, role: str = "farmer") -> User:
        user = User(phone=phone, role=role)
        db.add(user)
        db.commit()
        db.refresh(user)
        return user
