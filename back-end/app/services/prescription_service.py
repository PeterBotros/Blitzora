"""
Prescription service - business logic layer
"""
import os
import uuid
import json
import logging
from datetime import datetime
from typing import List, Optional
from fastapi import UploadFile
from sqlalchemy.orm import Session
from app.repositories.prescription_repository import PrescriptionRepository
from app.repositories.cart_repository import CartRepository
from app.models.catalog import Product
from app.services.gemini_service import GeminiService
from app.schemas.prescription import PrescriptionResponse
from app.core.exceptions import NotFoundError, ValidationError

logger = logging.getLogger(__name__)


class PrescriptionService:
    """Prescription service for business logic and file management"""

    def __init__(self, db: Session):
        self.db = db
        self.repository = PrescriptionRepository(db)
        self.gemini_service = GeminiService()

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
        diagnosis_date: str,
        file: UploadFile,
        notes: Optional[str] = None
    ) -> PrescriptionResponse:
        """Upload prescription file, analyze it via AI, validate signature/date, and save"""
        # Validate file presence and format
        if not file or not file.filename:
            raise ValidationError("No file uploaded or file name is missing")

        file_ext = os.path.splitext(file.filename)[1].lower()
        allowed_extensions = {".pdf", ".jpg", ".jpeg", ".png"}
        if file_ext not in allowed_extensions:
            raise ValidationError(
                f"Unsupported file type. Only PDF and images (JPG, PNG) are allowed. Got: {file_ext}"
            )

        # Parse diagnosis date
        try:
            diag_date = datetime.strptime(diagnosis_date.strip(), "%Y-%m-%d").date()
        except ValueError:
            raise ValidationError(
                f"Invalid diagnosis date format. Must be YYYY-MM-DD. Got: {diagnosis_date}"
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

        # ── Call Gemini AI to analyze the prescription ────────────────
        ai_result = await self.gemini_service.analyze_prescription(save_path)
        
        # Extract metadata from AI result
        is_presc = ai_result.get("is_prescription", True)
        sig_present = ai_result.get("doctor_signature_present", True)
        presc_date_str = ai_result.get("prescription_date")
        extracted_meds = ai_result.get("medicines", [])

        # Default validation variables
        is_valid = True
        rejection_reason = None
        status = "submitted"
        presc_date = None

        # Parse prescription date if found
        if presc_date_str:
            try:
                presc_date = datetime.strptime(presc_date_str.strip(), "%Y-%m-%d").date()
            except ValueError:
                pass

        # Perform verification checks (if API key is configured and AI analysis was done)
        if "error" not in ai_result or ai_result["error"] != "API key not configured":
            if not is_presc:
                is_valid = False
                rejection_reason = "The uploaded file does not appear to be a medical prescription."
                status = "rejected"
            elif not sig_present:
                is_valid = False
                rejection_reason = "The prescription must be signed/stamped by an actual doctor."
                status = "rejected"
            elif not presc_date:
                is_valid = False
                rejection_reason = "Could not identify a valid issue/prescription date on the document."
                status = "rejected"
            else:
                # Calculate absolute difference in days
                days_diff = abs((presc_date - diag_date).days)
                if days_diff > 3:
                    is_valid = False
                    rejection_reason = (
                        f"The prescription date ({presc_date}) cannot be more than 3 days "
                        f"from the diagnosis date ({diag_date}). Difference: {days_diff} days."
                    )
                    status = "rejected"
        else:
            rejection_reason = "AI verification bypassed: GEMINI_API_KEY is not configured."

        # If prescription is valid, match products and add to user's cart
        matched_product_ids = []
        if is_valid and extracted_meds:
            cart_repo = CartRepository(self.db)
            try:
                cart = cart_repo.get_by_user_id(user_id)
                for med_name in extracted_meds:
                    # Look up matching product in store (case-insensitive substring search)
                    # E.g. Med "Panadol Extra" matches Product name containing "Panadol"
                    product = (
                        self.db.query(Product)
                        .filter(Product.name.ilike(f"%{med_name}%"))
                        .first()
                    )
                    # If not found, try word-by-word fallback to match general brand
                    if not product and " " in med_name:
                        first_word = med_name.split()[0]
                        if len(first_word) > 2:
                            product = (
                                self.db.query(Product)
                                .filter(Product.name.ilike(f"%{first_word}%"))
                                .first()
                            )
                    
                    if product:
                        # Add item to user cart
                        cart_repo.add_item(cart_id=cart.id, product_id=product.id, quantity=1)
                        matched_product_ids.append(product.id)
                        logger.info(f"Automatically added matching product '{product.name}' to user cart.")
            except Exception as cart_err:
                logger.error(f"Failed to auto-add medicines to cart: {str(cart_err)}")

        # Create database record with AI validation details
        prescription = self.repository.create(
            user_id=user_id,
            patient_name=patient_name,
            address=address,
            file_path=file_url,
            notes=notes,
            diagnosis_date=diag_date,
            prescription_date=presc_date,
            is_valid=is_valid,
            rejection_reason=rejection_reason,
            extracted_medicines=json.dumps(extracted_meds),
            status=status
        )

        return PrescriptionResponse.model_validate(prescription)
