"""
Prescription repository - data access layer
"""
from sqlalchemy.orm import Session
from typing import Optional, List
from app.models.prescription import Prescription


class PrescriptionRepository:
    """Prescription repository for database operations"""

    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, prescription_id: str) -> Optional[Prescription]:
        """Get prescription by ID"""
        return self.db.query(Prescription).filter(Prescription.id == prescription_id).first()

    def get_user_prescription(self, prescription_id: str, user_id: str) -> Optional[Prescription]:
        """Get a prescription that belongs to a specific user"""
        return (
            self.db.query(Prescription)
            .filter(Prescription.id == prescription_id, Prescription.user_id == user_id)
            .first()
        )

    def get_all_by_user_id(self, user_id: str) -> List[Prescription]:
        """Get all prescriptions for a user ordered by creation time (newest first)"""
        return (
            self.db.query(Prescription)
            .filter(Prescription.user_id == user_id)
            .order_by(Prescription.created_at.desc())
            .all()
        )

    def create(
        self,
        user_id: str,
        patient_name: str,
        address: str,
        file_path: str,
        notes: Optional[str] = None,
        diagnosis_date: Optional[object] = None,
        prescription_date: Optional[object] = None,
        is_valid: bool = True,
        rejection_reason: Optional[str] = None,
        extracted_medicines: Optional[str] = None,
        status: str = "submitted",
    ) -> Prescription:
        """Create a new prescription record"""
        db_prescription = Prescription(
            user_id=user_id,
            patient_name=patient_name,
            address=address,
            file_path=file_path,
            notes=notes,
            diagnosis_date=diagnosis_date,
            prescription_date=prescription_date,
            is_valid=is_valid,
            rejection_reason=rejection_reason,
            extracted_medicines=extracted_medicines,
            status=status,
        )
        self.db.add(db_prescription)
        self.db.commit()
        self.db.refresh(db_prescription)
        return db_prescription

    def update_status(self, prescription: Prescription, status: str) -> Prescription:
        """Update the status of a prescription"""
        prescription.status = status
        self.db.commit()
        self.db.refresh(prescription)
        return prescription

    def delete(self, prescription: Prescription) -> bool:
        """Delete a prescription record"""
        self.db.delete(prescription)
        self.db.commit()
        return True
