from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from app.api.chat import router as chat_router
from app.api.user import router as user_router
from app.api.carbon_routes import router as carbon_router

import os

app = FastAPI(title="TechFiesta AI Backend")

# ✅ CORS — THIS WAS MISSING (CRITICAL)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],      # allow all for dev
    allow_credentials=True,
    allow_methods=["*"],      # allows OPTIONS, POST, GET
    allow_headers=["*"],
)

# Static audio
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
AUDIO_DIR = os.path.join(BASE_DIR, "../static/audio")
os.makedirs(AUDIO_DIR, exist_ok=True)

app.mount("/static/audio", StaticFiles(directory=AUDIO_DIR), name="static_audio")

# Routers
app.include_router(chat_router, prefix="/api/chat", tags=["Chat"])
app.include_router(user_router, prefix="/api/user", tags=["User"])
app.include_router(carbon_router, prefix="/api/carbon", tags=["Carbon Credits"])


@app.get("/health")
def health():
    return {"status": "TechFiesta backend running"}
