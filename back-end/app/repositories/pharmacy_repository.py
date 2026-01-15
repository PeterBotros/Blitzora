"""
Pharmacy repository - data access layer
"""
from sqlalchemy.orm import Session, noload
from typing import Optional, List
from decimal import Decimal
from app.models.pharmacy import Pharmacy


class PharmacyRepository:
    """Pharmacy repository for database operations"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_by_id(self, pharmacy_id: int) -> Optional[Pharmacy]:
        """Get pharmacy by ID"""
        return self.db.query(Pharmacy).filter(Pharmacy.id == pharmacy_id).first()
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[Pharmacy]:
        """Get all pharmacies"""
        return self.db.query(Pharmacy).options(
            noload(Pharmacy.inventory_items),
            noload(Pharmacy.orders)
        ).offset(skip).limit(limit).all()
    
    def get_nearby(
        self, 
        latitude: Decimal, 
        longitude: Decimal, 
        radius_km: float = 10.0,
        skip: int = 0,
        limit: int = 100
    ) -> List[Pharmacy]:
        """
        Get nearby pharmacies using simple distance calculation
        Note: For production, use proper geospatial queries
        """
        # Simple distance calculation (Haversine would be better)
        # This is a simplified version - in production use MySQL spatial functions
        pharmacies = self.db.query(Pharmacy).options(
            noload(Pharmacy.inventory_items),
            noload(Pharmacy.orders)
        ).filter(
            Pharmacy.latitude.isnot(None),
            Pharmacy.longitude.isnot(None)
        ).all()
        
        # Filter by distance (simplified - use proper geospatial in production)
        nearby = []
        for pharmacy in pharmacies:
            if pharmacy.latitude and pharmacy.longitude:
                # Simple distance check (rough approximation)
                lat_diff = abs(float(pharmacy.latitude) - float(latitude))
                lon_diff = abs(float(pharmacy.longitude) - float(longitude))
                # Rough conversion: 1 degree ≈ 111 km
                distance_km = ((lat_diff ** 2 + lon_diff ** 2) ** 0.5) * 111
                if distance_km <= radius_km:
                    nearby.append(pharmacy)
        
        return nearby[skip:skip + limit]

