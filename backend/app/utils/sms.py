import requests
import os
from typing import Optional

SMS_API_KEY = os.getenv("SMS_API_KEY")
SMS_API_URL = "https://www.fast2sms.com/dev/bulkV2"  # Example Fast2SMS API

def send_sms(phone: str, message: str) -> bool:
    """
    Send SMS using Fast2SMS API
    """
    if not SMS_API_KEY:
        print(f"SMS (dev): {message}")  # Fallback to console if no API key
        return True

    headers = {
        'authorization': SMS_API_KEY,
        'Content-Type': 'application/json'
    }

    payload = {
        "route": "v3",
        "sender_id": "TXTIND",
        "message": message,
        "language": "english",
        "flash": 0,
        "numbers": phone
    }

    try:
        response = requests.post(SMS_API_URL, headers=headers, json=payload)
        response.raise_for_status()
        return response.json().get('return', False)
    except Exception as e:
        print(f"SMS sending failed: {e}")
        return False
