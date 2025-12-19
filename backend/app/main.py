from fastapi import FastAPI
from app.api.chat import router as chat_router
from app.api.user import router as user_router

app = FastAPI(title="TechFiesta AI Backend")

# ✅ Register routers
app.include_router(chat_router, prefix="/api/chat", tags=["Chat"])
app.include_router(user_router, prefix="/api/user", tags=["User"])

@app.get("/health", tags=["Health"])
def health():
    return {"status": "TechFiesta backend running"}
