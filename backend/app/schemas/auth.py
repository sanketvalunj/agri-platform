from pydantic import BaseModel
from typing import Optional
from app.schemas.user import UserResponse

class LoginRequest(BaseModel):
    phone: str

class LoginResponse(BaseModel):
    otp_sent: bool
    session_id: str

class OTPVerifyRequest(BaseModel):
    session_id: str
    otp: str

class AuthResponse(BaseModel):
    access_token: str
    refresh_token: str
    user: UserResponse

class RefreshTokenRequest(BaseModel):
    refresh_token: str

class RefreshTokenResponse(BaseModel):
    access_token: str
    expires_in: int
