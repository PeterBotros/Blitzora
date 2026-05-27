"""
Address schemas
"""
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from decimal import Decimal


class AddressBase(BaseModel):
    """Base address schema"""
    label: Optional[str] = Field(None, max_length=255, description="e.g. Home, Work, Gym")
    street: Optional[str] = None
    building: Optional[str] = None
    apartment: Optional[str] = None
    floor: Optional[str] = Field(None, max_length=50)
    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None


class AddressCreate(AddressBase):
    """Address creation schema"""
    street: str = Field(..., description="Street details are required")


class AddressUpdate(BaseModel):
    """Address update schema"""
    label: Optional[str] = Field(None, max_length=255)
    street: Optional[str] = None
    building: Optional[str] = None
    apartment: Optional[str] = None
    floor: Optional[str] = Field(None, max_length=50)
    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None


class AddressResponse(AddressBase):
    """Address response schema"""
    id: int
    user_id: int
    created_at: datetime

    class Config:
        from_attributes = True
