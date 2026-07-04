"""
Prescription schemas - Pydantic validation and response models
"""
from pydantic import BaseModel, Field, field_validator
from datetime import datetime, date
from typing import Optional, List


class PrescriptionResponse(BaseModel):
    """Schema returned from the API"""
    id: str
    user_id: str
    patient_name: str
    address: str
    notes: Optional[str] = None
    file_path: str
    status: str
    
    # New AI verification fields
    diagnosis_date: Optional[date] = None
    prescription_date: Optional[date] = None
    is_valid: bool = True
    rejection_reason: Optional[str] = None
    extracted_medicines: Optional[List[str]] = None

    created_at: datetime
    updated_at: datetime

    @field_validator("extracted_medicines", mode="before")
    @classmethod
    def parse_extracted_medicines(cls, v):
        import json
        if isinstance(v, str):
            try:
                return json.loads(v)
            except Exception:
                return []
        return v

    class Config:
        from_attributes = True
