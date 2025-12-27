from datetime import datetime
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.models.market_price import MarketPrice

def normalize_record(record: dict):
    try:
        return {
            "commodity": record["commodity"],
            "state": record["state"],
            "district": record.get("district"),
            "mandi": record["market"],
            "min_price": float(record["min_price"]),
            "max_price": float(record["max_price"]),
            "modal_price": float(record["modal_price"]),
            "arrival_date": datetime.strptime(
                record["arrival_date"], "%d/%m/%Y"
            ).date(),
            "source": "AGMARKNET"
        }
    except Exception:
        return None

def get_price_summary(db, commodity: str, state: str):
    result = db.query(
        func.min(MarketPrice.min_price).label("min_price"),
        func.max(MarketPrice.max_price).label("max_price"),
        func.avg(MarketPrice.modal_price).label("avg_price")
    ).filter(
        MarketPrice.commodity == commodity,
        MarketPrice.state == state
    ).first()

    if not result or result.min_price is None:
        return None

    return {
        "min_price": float(result.min_price),
        "max_price": float(result.max_price),
        "avg_price": round(float(result.avg_price), 2)
    }

def save_market_prices(db: Session, records: list):
    for record in records:
        data = normalize_record(record)
        if not data:
            continue

        exists = db.query(MarketPrice).filter(
            MarketPrice.commodity == data["commodity"],
            MarketPrice.mandi == data["mandi"],
            MarketPrice.arrival_date == data["arrival_date"]
        ).first()

        if exists:
            continue

        db.add(MarketPrice(**data))

    db.commit()

def get_prices(db: Session, commodity: str, state: str, mandi: str | None):
    q = db.query(MarketPrice).filter(
        MarketPrice.commodity == commodity,
        MarketPrice.state == state,
    )

    if mandi:
        q = q.filter(MarketPrice.mandi == mandi)

    return q.order_by(MarketPrice.arrival_date.desc()).all()

