"""
Chatbot service - business logic layer
Fetches app context from DB and calls a local Ollama model
"""
import httpx
import json
from sqlalchemy.orm import Session
from typing import AsyncGenerator

from app.core.config import settings
from app.repositories.pharmacy_repository import PharmacyRepository
from app.repositories.product_repository import ProductRepository


SYSTEM_PROMPT = """
You are Blitz, a helpful pharmacy assistant for the Blitzora app.

You ONLY answer questions about:
- Medications and products available in the app
- Pharmacies listed in the app (locations, hours, delivery)
- Orders, delivery, and app-related questions
- General medicine usage, dosage, and side effects

If the user asks about anything outside these topics (politics, coding, sports, general knowledge, etc.),
respond with: "I'm only able to help with pharmacy and medicine-related questions through the Blitzora app."

Always be polite, clear, and concise. Do not make up products or pharmacies that are not in the context below.

{context}
"""


def _build_context(db: Session) -> str:
    """Fetch relevant data from DB and format it as plain text for the prompt"""

    pharmacy_repo = PharmacyRepository(db)
    product_repo = ProductRepository(db)

    pharmacies = pharmacy_repo.get_all(skip=0, limit=50)
    products = product_repo.get_all(skip=0, limit=100)

    # Format pharmacies
    pharmacy_lines = []
    for p in pharmacies:
        hours = ""
        if p.opens_at and p.closes_at:
            hours = f", Hours: {p.opens_at} - {p.closes_at}"
        delivery = "Delivery available" if p.delivery_available else "No delivery"
        pharmacy_lines.append(
            f"- {p.name} | {p.address or 'N/A'} | {p.phone or 'N/A'}{hours} | {delivery}"
        )

    # Format products
    product_lines = []
    for p in products:
        product_lines.append(
            f"- {p.name} | Category: {p.category_id or 'N/A'} | {'Available' if p.is_active else 'Unavailable'}"
        )

    context_parts = []
    if pharmacy_lines:
        context_parts.append("AVAILABLE PHARMACIES:\n" + "\n".join(pharmacy_lines))
    if product_lines:
        context_parts.append("AVAILABLE PRODUCTS:\n" + "\n".join(product_lines))

    return "\n\n".join(context_parts) if context_parts else "No data available currently."


class ChatbotService:
    """Chatbot service — builds context from DB and streams Ollama responses"""

    def __init__(self, db: Session):
        self.db = db
        self.ollama_url = settings.OLLAMA_URL
        self.ollama_model = settings.OLLAMA_MODEL

    async def stream_response(self, message: str) -> AsyncGenerator[str, None]:
        """Stream a response from Ollama based on the user message and DB context"""

        context = _build_context(self.db)
        system = SYSTEM_PROMPT.format(context=context)

        payload = {
            "model": self.ollama_model,
            "messages": [
                {"role": "system", "content": system},
                {"role": "user", "content": message},
            ],
            "stream": True,
        }

        async with httpx.AsyncClient(timeout=60.0) as client:
            async with client.stream("POST", f"{self.ollama_url}/api/chat", json=payload) as response:
                response.raise_for_status()
                async for line in response.aiter_lines():
                    if line:
                        chunk = json.loads(line)
                        token = chunk.get("message", {}).get("content", "")
                        if token:
                            yield token
                        if chunk.get("done"):
                            break