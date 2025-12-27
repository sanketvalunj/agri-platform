from fastapi import APIRouter
router=APIRouter()

@router.get("/")
def health_check():
    return{
        "status":"ok",
        "service":"Agri Platform Backend",
        "message":"Backend is running successfully"
    }