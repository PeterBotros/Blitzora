"""
Review schemas
"""
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class ReviewBase(BaseModel):
    """Base review schema"""
    rating: int = Field(..., ge=1, le=5, description="Rating must be between 1 and 5")
    comment: Optional[str] = None


class ReviewCreate(ReviewBase):
    """Review creation schema"""
    product_id: str


class ReviewResponse(ReviewBase):
    """Review response schema"""
    id: str
    user_id: str
    product_id: str
    created_at: datetime

    class Config:
        from_attributes = True
