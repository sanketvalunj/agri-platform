from fastapi import FastAPI
from app.api.chat import router as chat_router

app = FastAPI(title="TechFiesta AI Backend")

# Register routes
app.include_router(chat_router, prefix="/api")

@app.get("/health")
def health():
    return {"status": "TechFiesta backend running"}
