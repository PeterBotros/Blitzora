"""
Prescription service - business logic layer
"""
import os
import uuid
from typing import List, Optional
from fastapi import UploadFile
from sqlalchemy.orm import Session
from app.repositories.prescription_repository import PrescriptionRepository
from app.schemas.prescription import PrescriptionResponse
from app.core.exceptions import NotFoundError, ValidationError


class PrescriptionService:
    """Prescription service for business logic and file management"""

    def __init__(self, db: Session):
        self.repository = PrescriptionRepository(db)

    def get_all_user_prescriptions(self, user_id: str) -> List[PrescriptionResponse]:
        """Get all prescriptions for the authenticated user"""
        prescriptions = self.repository.get_all_by_user_id(user_id)
        return [PrescriptionResponse.model_validate(p) for p in prescriptions]

    def get_prescription(self, prescription_id: str, user_id: str) -> PrescriptionResponse:
        """Get prescription details by ID (ownership checked)"""
        prescription = self.repository.get_user_prescription(prescription_id, user_id)
        if not prescription:
            raise NotFoundError(f"Prescription with ID {prescription_id} not found")
        return PrescriptionResponse.model_validate(prescription)

    async def upload_prescription(
        self,
        user_id: str,
        patient_name: str,
        address: str,
        file: UploadFile,
        notes: Optional[str] = None
    ) -> PrescriptionResponse:
        """Upload prescription file and save database record"""
        # Validate file presence and format
        if not file or not file.filename:
            raise ValidationError("No file uploaded or file name is missing")

        file_ext = os.path.splitext(file.filename)[1].lower()
        allowed_extensions = {".pdf", ".jpg", ".jpeg", ".png"}
        if file_ext not in allowed_extensions:
            raise ValidationError(
                f"Unsupported file type. Only PDF and images (JPG, PNG) are allowed. Got: {file_ext}"
            )

        # Ensure directory exists
        upload_dir = os.path.join("uploads", "prescriptions")
        os.makedirs(upload_dir, exist_ok=True)

        # Generate unique filename to avoid overwrites
        filename = f"{uuid.uuid4()}{file_ext}"
        save_path = os.path.join(upload_dir, filename)

        # Write to disk
        try:
            content = await file.read()
            with open(save_path, "wb") as f:
                f.write(content)
        except Exception as e:
            raise ValidationError(f"Failed to save file on server: {str(e)}")

        # Relative path/url to reference via static mount
        file_url = f"/uploads/prescriptions/{filename}"

        # Create db record
        prescription = self.repository.create(
            user_id=user_id,
            patient_name=patient_name,
            address=address,
            file_path=file_url,
            notes=notes
        )

        return PrescriptionResponse.model_validate(prescription)
