"""
Prescription model - SQLAlchemy database schema
"""
from sqlalchemy import Column, DateTime, ForeignKey, String, Text, Date, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.database import Base
from app.core.utils import generate_uuid


class Prescription(Base):
    """Prescription database model"""
    __tablename__ = "prescriptions"

    id = Column(String(36), primary_key=True, index=True, default=generate_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    patient_name = Column(String(255), nullable=False)
    address = Column(String(255), nullable=False)
    notes = Column(Text, nullable=True)
    file_path = Column(String(512), nullable=False)  # Path to the file on server (e.g. /uploads/prescriptions/<filename>)
    status = Column(String(50), default="submitted", nullable=False)  # submitted, reviewed, fulfilled, rejected
    
    # AI verification fields
    diagnosis_date = Column(Date, nullable=True)
    prescription_date = Column(Date, nullable=True)
    is_valid = Column(Boolean, default=True, nullable=False)
    rejection_reason = Column(Text, nullable=True)
    extracted_medicines = Column(Text, nullable=True)  # JSON encoded list of medicines

    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    user = relationship("User", back_populates="prescriptions")
