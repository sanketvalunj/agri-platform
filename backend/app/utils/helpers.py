def is_crop_recommendation_intent(message: str) -> bool:
    keywords = [
        # Direct questions
        "which crop",
        "best crop",
        "suitable crop",
        "recommended crop",
        "crop recommendation",

        # Farmer-style questions
        "what should i grow",
        "what can i grow",
        "what crop to grow",
        "what to grow",

        # Soil / weather based
        "for my soil",
        "for my land",
        "based on soil",
        "based on weather",
        "for this season",
        "this season crop",

        # Indian farmer phrases
        "which crop is best",
        "suggest a crop",
        "crop suggestion",
        "farming advice crop",

        # Short / casual
        "best crop for me",
        "good crop",
        "ideal crop"
    ]

    msg = message.lower()
    return any(keyword in msg for keyword in keywords)
def is_weather_query(message: str) -> bool:
    keywords = [
        # General
        "weather",
        "climate",
        "temperature",
        "humidity",
        "rain",
        "rainfall",

        # Farmer-style
        "how is weather",
        "what is weather",
        "weather here",
        "today weather",
        "current weather",

        # Indian phrasing
        "aaj ka mausam",
        "barish hogi",
        "garmi kitni hai",
        "thand kitni hai",

        # Short casual
        "weather now",
        "outside weather",
        "mausam"
    ]

    msg = message.lower()
    return any(k in msg for k in keywords)
def is_location_query(message: str) -> bool:
    keywords = [
        # General
        "location",
        "where am i",
        "my place",
        "my area",

        # Administrative
        "state",
        "district",
        "region",
        "city",
        "village",

        # Coordinates
        "coordinates",
        "latitude",
        "longitude",
        "lat long",

        # Indian style
        "mera location",
        "mera shetra",
        "mera gaon",
        "mera district"
    ]

    msg = message.lower()
    return any(k in msg for k in keywords)
