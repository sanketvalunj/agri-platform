from typing import Optional

DISTRICT_SOIL_DATA = {
    "Pune": {
        "nitrogen": 85,
        "phosphorus": 40,
        "potassium": 38,
        "ph": 6.8
    },
    "Nashik": {
        "nitrogen": 78,
        "phosphorus": 35,
        "potassium": 30,
        "ph": 6.5
    }
}


def get_soil_data(district: str, user_soil: Optional[dict] = None) -> dict:
    """
    Returns soil data for crop recommendation.
    Priority:
    1. User-provided soil data
    2. District-level default soil data
    """

    # 🔹 If farmer manually entered soil values
    if user_soil:
        return user_soil

    # 🔹 Default district soil data
    soil = DISTRICT_SOIL_DATA.get(district)
    if not soil:
        # fallback to safe average instead of crashing
        return {
            "nitrogen": 80,
            "phosphorus": 38,
            "potassium": 35,
            "ph": 6.7
        }

    return soil
