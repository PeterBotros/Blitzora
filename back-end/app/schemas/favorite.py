"""
Favorite schemas
"""
from pydantic import BaseModel
from datetime import datetime
from typing import Optional
from app.schemas.product import ProductResponse


class FavoriteResponse(BaseModel):
    """Favorite response schema"""
    id: str
    user_id: str
    product_id: str
    created_at: datetime
    product: Optional[ProductResponse] = None

    class Config:
        from_attributes = True
