"""
Notification schemas
"""
from pydantic import BaseModel
from datetime import datetime


class NotificationCreate(BaseModel):
    """Notification creation schema"""
    user_id: str
    title: str
    content: str


class NotificationResponse(BaseModel):
    """Notification response schema"""
    id: str
    user_id: str
    title: str
    content: str
    is_read: bool
    created_at: datetime

    class Config:
        from_attributes = True
