from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from app.api.chat import router as chat_router
from app.api.user import router as user_router
from app.api.carbon_routes import router as carbon_router

import os
from dotenv import load_dotenv
from app.api.v1.weather import router as weather_router
from app.api.v1.market import router as market_router
from app.api.v1.auth import router as auth_router
load_dotenv() 

app = FastAPI(
    title="Agri Platform Backend",
    description="Backend APIs for Agri Advisory System",
    version="1.0.0"
)

# ---------------- CORS ----------------
app.add_middleware(
    CORSMiddleware,
      allow_origins=["*"],
 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------------- Static files ----------------
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
STATIC_DIR = os.path.join(BASE_DIR, "../static")
os.makedirs(STATIC_DIR, exist_ok=True)

app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")

# ---------------- ROUTES ----------------
app.include_router(weather_router, prefix="/api")
app.include_router(market_router, prefix="/api")
app.include_router(auth_router, prefix="/api")
# Routers
app.include_router(chat_router, prefix="/api/chat", tags=["Chat"])
app.include_router(user_router, prefix="/api/user", tags=["User"])
app.include_router(carbon_router, prefix="/api/carbon", tags=["Carbon Credits"])


@app.get("/")
def root():
    return {"status": "Agri Backend Running"}
