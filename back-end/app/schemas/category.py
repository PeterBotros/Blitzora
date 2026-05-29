"""
Category schemas
"""
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class CategoryBase(BaseModel):
    """Base category schema"""
    name: str = Field(..., min_length=1, max_length=255)
    image_url: Optional[str] = None


class CategoryCreate(CategoryBase):
    """Category creation schema"""
    pass


class CategoryUpdate(BaseModel):
    """Category update schema"""
    name: Optional[str] = Field(None, min_length=1, max_length=255)
    image_url: Optional[str] = None


class CategoryResponse(CategoryBase):
    """Category response schema"""
    id: int
    created_at: datetime

    class Config:
        from_attributes = True
