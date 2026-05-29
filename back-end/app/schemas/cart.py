"""
Cart schemas
"""
from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime
from app.schemas.product import ProductResponse


class CartItemBase(BaseModel):
    """Base cart item schema"""
    product_id: int
    quantity: int = Field(..., ge=1, description="Quantity must be at least 1")


class CartItemCreate(CartItemBase):
    """Cart item creation schema"""
    pass


class CartItemUpdate(BaseModel):
    """Cart item update schema"""
    quantity: int = Field(..., ge=1, description="Quantity must be at least 1")


class CartItemResponse(BaseModel):
    """Cart item response schema"""
    id: int
    cart_id: int
    product_id: int
    quantity: int
    product: Optional[ProductResponse] = None

    class Config:
        from_attributes = True


class CartResponse(BaseModel):
    """Cart response schema"""
    id: int
    user_id: int
    created_at: datetime
    items: List[CartItemResponse] = []

    class Config:
        from_attributes = True
