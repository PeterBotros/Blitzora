"""
Reminder schemas - Pydantic validation and response models
"""
from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional


class ReminderBase(BaseModel):
    """Shared reminder fields"""
    name: str = Field(..., max_length=255, description="Medicine name")
    dosage: str = Field(..., max_length=255, description="Dose description e.g. '1 tablet'")
    time: str = Field(..., max_length=50, description="Scheduled time e.g. '08:00 AM'")
    icon_type: str = Field("pill", max_length=50, description="Icon type: pill | water | healing | pharmacy")
    is_taken: bool = Field(False, description="Whether the dose has been taken today")


class ReminderCreate(ReminderBase):
    """Schema for creating a new reminder"""
    pass


class ReminderUpdate(BaseModel):
    """Schema for partially updating a reminder"""
    name: Optional[str] = Field(None, max_length=255)
    dosage: Optional[str] = Field(None, max_length=255)
    time: Optional[str] = Field(None, max_length=50)
    icon_type: Optional[str] = Field(None, max_length=50)
    is_taken: Optional[bool] = None


class ReminderResponse(ReminderBase):
    """Schema returned from the API"""
    id: str
    user_id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
