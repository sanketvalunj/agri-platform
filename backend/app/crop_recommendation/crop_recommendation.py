import requests
import os

API_KEY = os.getenv("WEATHER_API_KEY")  # put in .env

DISTRICTS = {
    "Pune": {"lat": 18.5204, "lon": 73.8567},
    "Nashik": {"lat": 19.9975, "lon": 73.7898},
    "Mumbai": {"lat": 19.0760, "lon": 72.8777},
}

def get_weather(district: str):
    if district not in DISTRICTS:
        return {"error": "Invalid district"}

    lat = DISTRICTS[district]["lat"]
    lon = DISTRICTS[district]["lon"]

    url = (
        f"https://api.openweathermap.org/data/2.5/weather"
        f"?lat={lat}&lon={lon}&units=metric&appid={API_KEY}"
    )

    res = requests.get(url).json()

    return {
        "temperature": res["main"]["temp"],
        "humidity": res["main"]["humidity"],
        "rainfall": res.get("rain", {}).get("1h", 0),
        "description": res["weather"][0]["description"]
    }
