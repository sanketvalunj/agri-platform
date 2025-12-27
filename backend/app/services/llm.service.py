from langchain_groq import ChatGroq
from langchain_core.messages import SystemMessage, HumanMessage

from app.core.config import GROQ_API_KEY
from app.memory.conversation import get_history, add_message

# Initialize LLM
llm = ChatGroq(
    groq_api_key=GROQ_API_KEY,
    model_name="llama-3.1-8b-instant",
    temperature=0.4,
)

SYSTEM_PROMPT = """
You are TechFiesta Krishi Advisor AI.

Your users are farmers.

RULES YOU MUST FOLLOW:
* Answer in bullet points only
* Keep answers short and precise
* Avoid theory
* Use simple farmer-friendly language

FORMAT:
* Point 1
* Point 2
"""

def generate_reply(user_id: str, user_message: str) -> str:
    history = get_history(user_id)

    messages = [SystemMessage(content=SYSTEM_PROMPT)]

    for msg in history:
        messages.append(HumanMessage(content=msg["content"]))

    messages.append(HumanMessage(content=user_message))

    response = llm(messages).content

    add_message(user_id, "user", user_message)
    add_message(user_id, "assistant", response)

    return response
