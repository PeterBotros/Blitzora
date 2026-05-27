"""
Pharmacy schemas
"""

from pydantic import BaseModel, ConfigDict, field_serializer
from typing import Optional
from datetime import datetime, time
from decimal import Decimal


# ============================================
# BASE SCHEMA
# ============================================
class PharmacyBase(BaseModel):
    name: str
    address: Optional[str] = None

    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None

    phone: Optional[str] = None

    opens_at: Optional[time] = None
    closes_at: Optional[time] = None


# ============================================
# CREATE SCHEMA
# ============================================
class PharmacyCreate(PharmacyBase):
    pass


# ============================================
# UPDATE SCHEMA
# ============================================
class PharmacyUpdate(BaseModel):
    name: Optional[str] = None
    address: Optional[str] = None

    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None

    phone: Optional[str] = None

    opens_at: Optional[time] = None
    closes_at: Optional[time] = None


# ============================================
# RESPONSE SCHEMA
# ============================================
class PharmacyResponse(PharmacyBase):
    id: int
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

    @field_serializer("latitude", "longitude")
    def serialize_decimal(self, value: Optional[Decimal]):
        if value is None:
            return None
        return float(value)

    @field_serializer("opens_at", "closes_at")
    def serialize_time(self, value: Optional[time]):
        if value is None:
            return None
        return value.strftime("%H:%M:%S")


# ============================================
# NEARBY RESPONSE
# ============================================
class PharmacyNearbyResponse(PharmacyResponse):
    distance_km: Optional[float] = None