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
    product_id: int


class ReviewResponse(ReviewBase):
    """Review response schema"""
    id: int
    user_id: int
    product_id: int
    created_at: datetime

    class Config:
        from_attributes = True
