import requests
import os

API_KEY = os.getenv("WEATHER_API_KEY")

DISTRICT_COORDS = {
    "Pune": {"lat": 18.5204, "lon": 73.8567},
    "Nashik": {"lat": 19.9975, "lon": 73.7898}
}

def fetch_weather_by_district(district: str):
    coords = DISTRICT_COORDS.get(district)
    if not coords:
        raise ValueError("Unsupported district")

    url = (
        f"https://api.openweathermap.org/data/2.5/weather"
        f"?lat={coords['lat']}&lon={coords['lon']}"
        f"&appid={API_KEY}&units=metric"
    )

    res = requests.get(url).json()

    return {
        "temperature": res["main"]["temp"],
        "humidity": res["main"]["humidity"],
        "rainfall": res.get("rain", {}).get("1h", 0) * 24
    }
