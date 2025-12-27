from fastapi import APIRouter, Depends,HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.db.database import SessionLocal
from app.schemas.market_price import MarketPriceResponse
from app.services.market_service import get_price_summary
from app.models.market_price import MarketPrice

router = APIRouter(prefix="/market", tags=["Market"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/prices")
def get_market_prices(
    commodity: str = "Tomato",
    state: str | None = None,
    db: Session = Depends(get_db)
):
    query = db.query(MarketPrice)

    if commodity:
        query = query.filter(MarketPrice.commodity == commodity)

    if state:
        query = query.filter(MarketPrice.state == state)

    # Always return something
    results = query.order_by(MarketPrice.arrival_date.desc()).limit(10).all()

    return results


@router.get("/summary")
def get_market_summary(
    commodity: str,
    state: str,
    db: Session = Depends(get_db)
):
    result = (
        db.query(
            func.min(MarketPrice.min_price).label("min"),
            func.max(MarketPrice.max_price).label("max"),
            func.avg(MarketPrice.modal_price).label("avg"),
        )
        .filter(
            MarketPrice.commodity == commodity,
            MarketPrice.state == state
        )
        .first()
    )

    if not result or result.min is None:
        return {"message": "No data available"}

    return {
        "commodity": commodity,
        "state": state,
        "min_price": result.min,
        "max_price": result.max,
        "avg_price": round(result.avg, 2),
    }



