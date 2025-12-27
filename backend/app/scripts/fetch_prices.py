import requests
from app.db.database import SessionLocal
from app.models.market_price import MarketPrice
from datetime import datetime

API_URL = "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070"
API_KEY = "579b464db66ec23bdd00000182f08e2ed40f45147fa2e1a750dd4ff6"


def fetch_market_data():
    params = {
        "api-key": API_KEY,
        "format": "json",
        "limit": 100,
    }

    response = requests.get(API_URL, params=params, timeout=20)
    response.raise_for_status()
    return response.json().get("records", [])


def save_market_data():
    db = SessionLocal()
    records = fetch_market_data()

    inserted = 0

    for r in records:
        try:
            item = MarketPrice(
                commodity=r["commodity"],
                state=r["state"],
                mandi=r["market"],
                min_price=float(r["min_price"]),
                max_price=float(r["max_price"]),
                modal_price=float(r["modal_price"]),
                arrival_date=datetime.strptime(r["arrival_date"], "%d/%m/%Y")
            )

            exists = db.query(MarketPrice).filter_by(
                commodity=item.commodity,
                mandi=item.mandi,
                arrival_date=item.arrival_date
            ).first()

            if not exists:
                db.add(item)
                inserted += 1

        except Exception as e:
            print("❌ Skipped record:", e)

    db.commit()
    print(f"✅ Inserted {inserted} records")


# ⭐ THIS PART WAS MISSING
if __name__ == "__main__":
    save_market_data()
