"""
Pharmacy schemas
"""
from pydantic import BaseModel, field_serializer
from typing import Optional, Union
from datetime import datetime, time
from decimal import Decimal


class PharmacyResponse(BaseModel):
    """Pharmacy response schema"""
    id: int
    name: str
    address: Optional[str] = None
    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None
    phone: Optional[str] = None
    opens_at: Optional[Union[time, str]] = None  # Accept time or string
    closes_at: Optional[Union[time, str]] = None  # Accept time or string
    created_at: datetime

    @field_serializer('opens_at', 'closes_at')
    def serialize_time(self, value: Optional[Union[time, str]], _info):
        """Convert time object to string for JSON serialization"""
        if value is None:
            return None
        if isinstance(value, time):
            return value.strftime('%H:%M:%S')
        # If it's already a string, return as is
        return str(value)

    class Config:
        from_attributes = True

