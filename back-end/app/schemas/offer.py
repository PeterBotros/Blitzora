"""
Offer schemas
"""
from pydantic import BaseModel
from typing import Optional
from datetime import date


class OfferResponse(BaseModel):
    """Offer response schema"""
    id: str
    title: str
    description: Optional[str] = None
    discount_percent: int
    start_date: date
    end_date: date
    product_id: Optional[str] = None
    is_global: bool = False

    class Config:
        from_attributes = True

