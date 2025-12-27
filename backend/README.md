# Agri Platform Backend

This is the FastAPI backend for the Agri Platform, implementing OTP-based authentication.

## Setup

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Run the server:
   ```bash
   uvicorn app.main:app --reload
   ```

The server will start on http://127.0.0.1:8000

## API Documentation

Once the server is running, visit http://127.0.0.1:8000/docs for interactive API documentation.

## Authentication Endpoints

- POST /api/auth/send-otp: Send OTP to phone number
- POST /api/auth/verify-otp: Verify OTP and get JWT token

## Database

Uses SQLite for local development. Database file: agri_platform.db
