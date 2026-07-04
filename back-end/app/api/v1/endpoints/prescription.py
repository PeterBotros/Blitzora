"""
Prescription endpoints - POST, GET
"""
from fastapi import APIRouter, Depends, File, Form, UploadFile, status
from sqlalchemy.orm import Session
from typing import List, Optional

from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User
from app.schemas.prescription import PrescriptionResponse
from app.services.prescription_service import PrescriptionService
from app.core.exceptions import NotFoundError, ValidationError, not_found_exception, validation_exception

router = APIRouter()


@router.post("/", response_model=PrescriptionResponse, status_code=status.HTTP_201_CREATED)
async def upload_prescription(
    patient_name: str = Form(...),
    address: str = Form(...),
    notes: Optional[str] = Form(None),
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Upload a new doctor prescription (PDF or Image) and create a database entry"""
    service = PrescriptionService(db)
    try:
        return await service.upload_prescription(
            user_id=current_user.id,
            patient_name=patient_name,
            address=address,
            file=file,
            notes=notes,
        )
    except ValidationError as e:
        raise validation_exception(str(e))
    except Exception as e:
        raise validation_exception(f"Error uploading prescription: {str(e)}")


@router.get("/", response_model=List[PrescriptionResponse])
async def get_prescriptions(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Retrieve all prescriptions uploaded by the authenticated user"""
    service = PrescriptionService(db)
    return service.get_all_user_prescriptions(current_user.id)


@router.get("/{prescription_id}", response_model=PrescriptionResponse)
async def get_prescription(
    prescription_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Retrieve details of a specific prescription"""
    service = PrescriptionService(db)
    try:
        return service.get_prescription(prescription_id, current_user.id)
    except NotFoundError as e:
        raise not_found_exception(str(e))
