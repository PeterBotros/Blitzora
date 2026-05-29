"""
Favorite schemas
"""
from pydantic import BaseModel
from datetime import datetime
from typing import Optional
from app.schemas.product import ProductResponse


class FavoriteResponse(BaseModel):
    """Favorite response schema"""
    id: int
    user_id: int
    product_id: int
    created_at: datetime
    product: Optional[ProductResponse] = None

    class Config:
        from_attributes = True
