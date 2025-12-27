from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime, timedelta

from app.db.dependencies import get_db
from app.models.user import User
from app.models.otp import OTP
from app.utils.security import generate_otp, create_access_token
from app.utils.sms import send_sms

router = APIRouter(prefix="/auth", tags=["Auth"])
@router.post("/send-otp")
def send_otp(phone: str, db: Session = Depends(get_db)):
    otp = str(generate_otp())

    db.query(OTP).filter(OTP.phone == phone).delete()

    db.add(OTP(
        phone=phone,
        otp=otp,
        expires_at=datetime.utcnow() + timedelta(minutes=5)
    ))
    db.commit()

    message = f"Your OTP for Agri Platform is: {otp}. Valid for 5 minutes."
    sms_sent = send_sms(phone, message)

    if not sms_sent:
        # If SMS fails, still return success but log the OTP for development
        print(f"OTP (SMS failed, dev fallback): {otp}")
        return {"message": "OTP sent successfully (dev mode)"}

    return {"message": "OTP sent successfully"}


@router.post("/verify-otp")
def verify_otp(phone: str, otp: str, db: Session = Depends(get_db)):
    record = db.query(OTP).filter(
        OTP.phone == phone,
        OTP.otp == otp
    ).first()

    if not record or record.expires_at < datetime.utcnow():
        raise HTTPException(status_code=400, detail="Invalid or expired OTP")

    db.delete(record)
    db.commit()

    user = db.query(User).filter(User.phone == phone).first()
    if not user:
        user = User(phone=phone, is_verified=True)
        db.add(user)
        db.commit()

    token = create_access_token({"sub": phone})
    return {"token": token}
