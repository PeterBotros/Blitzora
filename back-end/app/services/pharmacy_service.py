"""
Pharmacy service - business logic layer
"""
from sqlalchemy.orm import Session
from typing import Optional, List
from decimal import Decimal
from app.repositories.pharmacy_repository import PharmacyRepository
from app.schemas.pharmacy import PharmacyResponse
from app.core.exceptions import NotFoundError


class PharmacyService:
    """Pharmacy service for business logic"""
    
    def __init__(self, db: Session):
        self.repository = PharmacyRepository(db)
    
    def get_pharmacy_by_id(self, pharmacy_id: str) -> PharmacyResponse:
        """Get pharmacy by ID"""
        pharmacy = self.repository.get_by_id(pharmacy_id)
        if not pharmacy:
            raise NotFoundError(f"Pharmacy with ID {pharmacy_id} not found")
        return PharmacyResponse.model_validate(pharmacy)
    
    def get_all_pharmacies(self, skip: int = 0, limit: int = 100) -> List[PharmacyResponse]:
        """Get all pharmacies"""
        pharmacies = self.repository.get_all(skip, limit)
        return [PharmacyResponse.model_validate(p) for p in pharmacies]
    
    def get_nearby_pharmacies(
        self,
        latitude: Decimal,
        longitude: Decimal,
        radius_km: float = 10.0,
        skip: int = 0,
        limit: int = 100
    ) -> List[PharmacyResponse]:
        """Get nearby pharmacies"""
        pharmacies = self.repository.get_nearby(latitude, longitude, radius_km, skip, limit)
        return [PharmacyResponse.model_validate(p) for p in pharmacies]

