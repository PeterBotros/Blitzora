"""
Chatbot endpoint
"""
from fastapi import APIRouter, Depends
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from pydantic import BaseModel

from app.core.database import get_db
from app.services.chatbot_service import ChatbotService

router = APIRouter(
    tags=["Chatbot"]
)


# ============================================
# REQUEST SCHEMA
# ============================================
class ChatRequest(BaseModel):
    message: str


# ============================================
# CHAT — STREAMING
# ============================================
@router.post("/chat")
async def chat(
    request: ChatRequest,
    db: Session = Depends(get_db)
):
    """
    Send a message to the Blitzora pharmacy chatbot.
    Returns a streaming plain-text response.
    """
    service = ChatbotService(db)

    return StreamingResponse(
        service.stream_response(request.message),
        media_type="text/plain"
    )
