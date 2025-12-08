"""
Product schemas
"""
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from decimal import Decimal
from app.schemas.category import CategoryResponse


class ProductImageResponse(BaseModel):
    """Product image response schema"""
    id: int
    image_url: str

    class Config:
        from_attributes = True


class ProductResponse(BaseModel):
    """Product response schema"""
    id: int
    name: str
    description: Optional[str] = None
    category_id: Optional[int] = None
    price: Decimal
    discount_percent: int = 0
    stock: int = 0
    image_url: Optional[str] = None
    is_featured: bool = False
    created_at: datetime
    category: Optional[CategoryResponse] = None
    images: List[ProductImageResponse] = []

    class Config:
        from_attributes = True


class ProductListResponse(BaseModel):
    """Product list response schema"""
    id: int
    name: str
    description: Optional[str] = None
    category_id: Optional[int] = None
    price: Decimal
    discount_percent: int = 0
    stock: int = 0
    image_url: Optional[str] = None
    is_featured: bool = False
    created_at: datetime

    class Config:
        from_attributes = True

