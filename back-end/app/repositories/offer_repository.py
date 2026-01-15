"""
Offer repository - data access layer
"""
from sqlalchemy.orm import Session
from typing import Optional, List
from datetime import date
from app.models.catalog import Offer


class OfferRepository:
    """Offer repository for database operations"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_by_id(self, offer_id: int) -> Optional[Offer]:
        """Get offer by ID"""
        return self.db.query(Offer).filter(Offer.id == offer_id).first()
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[Offer]:
        """Get all offers"""
        return self.db.query(Offer).offset(skip).limit(limit).all()
    
    def get_active(self, skip: int = 0, limit: int = 100) -> List[Offer]:
        """Get active offers (current date between start and end)"""
        today = date.today()
        return self.db.query(Offer).filter(
            Offer.start_date <= today,
            Offer.end_date >= today
        ).offset(skip).limit(limit).all()
    
    def get_global_offers(self, skip: int = 0, limit: int = 100) -> List[Offer]:
        """Get global offers (not product-specific)"""
        today = date.today()
        return self.db.query(Offer).filter(
            Offer.is_global == True,
            Offer.start_date <= today,
            Offer.end_date >= today
        ).offset(skip).limit(limit).all()

