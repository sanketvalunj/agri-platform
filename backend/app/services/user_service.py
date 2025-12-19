USER_LOCATION_STORE = {}

def save_user_location(user_id: str, location: dict):
    USER_LOCATION_STORE[user_id] = location

def get_user_location(user_id: str):
    return USER_LOCATION_STORE.get(user_id)
