"""
Offer service - business logic layer
"""
from sqlalchemy.orm import Session
from typing import List
from app.repositories.offer_repository import OfferRepository
from app.schemas.offer import OfferResponse


class OfferService:
    """Offer service for business logic"""
    
    def __init__(self, db: Session):
        self.repository = OfferRepository(db)
    
    def get_all_offers(self, skip: int = 0, limit: int = 100) -> List[OfferResponse]:
        """Get all offers"""
        offers = self.repository.get_all(skip, limit)
        return [OfferResponse.model_validate(o) for o in offers]
    
    def get_active_offers(self, skip: int = 0, limit: int = 100) -> List[OfferResponse]:
        """Get active offers"""
        offers = self.repository.get_active(skip, limit)
        return [OfferResponse.model_validate(o) for o in offers]
    
    def get_global_offers(self, skip: int = 0, limit: int = 100) -> List[OfferResponse]:
        """Get global offers"""
        offers = self.repository.get_global_offers(skip, limit)
        return [OfferResponse.model_validate(o) for o in offers]

