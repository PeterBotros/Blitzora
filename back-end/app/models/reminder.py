"""
Reminder model - SQLAlchemy database schema
"""
from sqlalchemy import Boolean, Column, DateTime, ForeignKey, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.database import Base
from app.core.utils import generate_uuid


class Reminder(Base):
    """Medication Reminder database model"""
    __tablename__ = "reminders"

    id = Column(String(36), primary_key=True, index=True, default=generate_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    name = Column(String(255), nullable=False)
    dosage = Column(String(255), nullable=False)
    time = Column(String(50), nullable=False)  # e.g., "08:00 AM"
    is_taken = Column(Boolean, default=False, nullable=False)
    icon_type = Column(String(50), default="pill", nullable=False)  # pill, water, healing, pharmacy
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    user = relationship("User", back_populates="reminders")
