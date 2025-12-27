import requests
from datetime import datetime

AGMARKNET_API_URL = "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070"

API_KEY = "PUT_YOUR_DATA_GOV_API_KEY_HERE"

def fetch_market_data(commodity: str, state: str):
    params = {
        "api-key": API_KEY,
        "format": "json",
        "filters[commodity]": commodity,
        "filters[state]": state,
        "limit": 20
    }
    

    response = requests.get(AGMARKNET_API_URL, params=params, timeout=10)
    response.raise_for_status()
    return response.json()["records"]
def normalize_record(record):
    try:
        return {
            "commodity": record["commodity"],
            "mandi": record["market"],
            "state": record["state"],
            "min_price": float(record["min_price"]),
            "max_price": float(record["max_price"]),
            "modal_price": float(record["modal_price"]),
            "arrival_date": datetime.strptime(
                record["arrival_date"], "%d/%m/%Y"
            ).date(),
        }
    except Exception:
        return None
from app.models.market_price import MarketPrice

def save_market_prices(db, records):
    for record in records:
        data = normalize_record(record)
        if not data:
            continue

        exists = db.query(MarketPrice).filter(
            MarketPrice.commodity == data["commodity"],
            MarketPrice.mandi == data["mandi"],
            MarketPrice.arrival_date == data["arrival_date"]
        ).first()

        if not exists:
            db.add(MarketPrice(**data))

    db.commit()

