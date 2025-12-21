from fastapi import APIRouter
from app.models.chat_models import ChatRequest, ChatResponse
from app.services.llm_service import generate_reply
from app.services.crop_service import recommend_crop
from app.services.weather_service import fetch_weather_by_district
from app.services.soil_service import get_soil_data
from app.services.user_service import get_user_location
from app.utils.helpers import (
    is_crop_recommendation_intent,
    is_location_query,
    is_weather_query
)

router = APIRouter()

@router.post("/", response_model=ChatResponse)

def chat_endpoint(request: ChatRequest):

    user_message = request.message.strip()

    # 📍 LOCATION QUERY (STRICT – NO LLM GUESSING)
    if is_location_query(user_message):

        location = get_user_location(request.user_id)

        if not location:
            return ChatResponse(
                reply="I don’t have your location yet. Please select it in the setup screen.",
                confidence=0.3
            )

        reply = (
            "Your location details:\n"
            f"- State: {location.get('state')}\n"
            f"- District: {location.get('district')}\n"
        )

        if location.get("village"):
            reply += f"- Village: {location.get('village')}\n"

        return ChatResponse(
            reply=reply,
            confidence=0.95
        )

    # 🌦️ WEATHER QUERY (STRICT – NO LLM GUESSING)
    if is_weather_query(user_message):

        location = get_user_location(request.user_id)

        if not location:
            return ChatResponse(
                reply="Please select your location first so I can tell you the weather.",
                confidence=0.3
            )

        district = location.get("district")

        try:
            weather = fetch_weather_by_district(district)
        except Exception as e:
            print("❌ Weather error:", e)
            return ChatResponse(
                reply="I am unable to fetch weather data right now.",
                confidence=0.3
            )

        reply = (
            f"Current weather in {district}:\n"
            f"- Temperature: {weather.get('temperature')}°C\n"
            f"- Humidity: {weather.get('humidity')}%\n"
            f"- Rainfall: {weather.get('rainfall')} mm\n"
        )

        return ChatResponse(
            reply=reply,
            confidence=0.95
        )

    # 🌱 CROP RECOMMENDATION FLOW
    if is_crop_recommendation_intent(user_message):

        print("👉 Crop intent detected")

        location = get_user_location(request.user_id)

        if not location:
            return ChatResponse(
                reply="Please select your location first to get crop recommendations.",
                confidence=0.4
            )

        district = location.get("district")
        print("👉 District:", district)

        # 🌦️ Weather
        try:
            weather = fetch_weather_by_district(district)
        except Exception as e:
            print("❌ Weather fetch error:", e)
            return ChatResponse(
                reply="Unable to fetch weather data right now. Please try again later.",
                confidence=0.4
            )

        # 🧪 Soil
        try:
            soil = get_soil_data(
                district=district,
                user_soil=request.soil_data.dict() if request.soil_data else None
            )
        except Exception as e:
            print("❌ Soil data error:", e)
            return ChatResponse(
                reply="Soil data not available for your location.",
                confidence=0.4
            )

        # 🔗 Final ML input
        final_input = {**soil, **weather}

        print("👉 Weather:", weather)
        print("👉 Soil:", soil)
        print("👉 Final ML input:", final_input)

        # 🤖 ML Prediction
        try:
            ml_result = recommend_crop(final_input)
        except Exception as e:
            print("❌ ML error:", e)
            return ChatResponse(
                reply="I could not determine the best crop right now.",
                confidence=0.4
            )

        system_prompt = f"""
You are an agricultural advisor.

A machine learning model has recommended this crop:

Recommended Crop: {ml_result['crop']}

Explain why this crop is suitable for the local soil and weather.
Use simple farmer-friendly language.
Give 2–3 practical next steps.
Do NOT change the crop.
Never guess location, region, coordinates, or weather.
Use ONLY the data provided.
"""

        reply = generate_reply(
            user_id=request.user_id,
            user_message=system_prompt
        )

        return ChatResponse(
            reply=reply,
            confidence=0.95
        )

    # 💬 NORMAL CHAT (LLM ONLY – NO FACTUAL DATA)
    reply = generate_reply(
        user_id=request.user_id,
        user_message=user_message
    )

    return ChatResponse(
        reply=reply,
        confidence=0.87
    )
