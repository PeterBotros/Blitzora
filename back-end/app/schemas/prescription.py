"""
Prescription schemas - Pydantic validation and response models
"""
from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional


class PrescriptionResponse(BaseModel):
    """Schema returned from the API"""
    id: str
    user_id: str
    patient_name: str
    address: str
    notes: Optional[str] = None
    file_path: str
    status: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
