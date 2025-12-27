from fastapi import APIRouter
import requests
from dotenv import load_dotenv
import os

load_dotenv() 
router = APIRouter(prefix="/weather", tags=["Weather"])

API_KEY = os.getenv("WEATHER_API_KEY")
print("WEATHER KEY:", API_KEY)

@router.get("/")
def get_weather(city: str):
    if not API_KEY:
        return {"error": "WEATHER_API_KEY not configured"}

    url = (
        f"https://api.openweathermap.org/data/2.5/weather"
        f"?q={city}&appid={API_KEY}&units=metric"
    )

    res = requests.get(url)
    if res.status_code != 200:
        return {"error": res.json().get("message", "Weather API error")}

    data = res.json()
    return {
        "city": city,
        "temperature": data["main"]["temp"],
        "humidity": data["main"]["humidity"],
        "description": data["weather"][0]["description"],
    }
