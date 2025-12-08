"""
Category schemas
"""
from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class CategoryResponse(BaseModel):
    """Category response schema"""
    id: int
    name: str
    image_url: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True

