from collections import defaultdict

# Simple in-memory conversation store (hackathon-safe)
conversation_store = defaultdict(list)

def get_history(user_id: str):
    """
    Returns last 5 messages for a user
    """
    return conversation_store[user_id][-5:]

def add_message(user_id: str, role: str, content: str):
    """
    Stores a message in memory
    """
    conversation_store[user_id].append({
        "role": role,
        "content": content
    })
