"""
Address repository - data access layer
"""
from sqlalchemy.orm import Session
from typing import Optional, List
from app.models.pharmacy import Address
from app.schemas.address import AddressCreate


class AddressRepository:
    """Address repository for database operations"""

    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, address_id: str) -> Optional[Address]:
        """Get address by ID"""
        return self.db.query(Address).filter(Address.id == address_id).first()

    def get_user_address(self, address_id: str, user_id: str) -> Optional[Address]:
        """Get an address for a specific user to prevent unauthorized cross-access"""
        return (
            self.db.query(Address)
            .filter(Address.id == address_id, Address.user_id == user_id)
            .first()
        )

    def get_all_by_user_id(self, user_id: str) -> List[Address]:
        """Get all addresses for a user"""
        return self.db.query(Address).filter(Address.user_id == user_id).all()

    def create(self, user_id: str, address_data: AddressCreate) -> Address:
        """Create a new delivery address"""
        db_address = Address(
            user_id=user_id,
            label=address_data.label,
            street=address_data.street,
            building=address_data.building,
            apartment=address_data.apartment,
            floor=address_data.floor,
            latitude=address_data.latitude,
            longitude=address_data.longitude
        )
        self.db.add(db_address)
        self.db.commit()
        self.db.refresh(db_address)
        return db_address

    def update(self, address: Address, update_data: dict) -> Address:
        """Update address fields"""
        for field, value in update_data.items():
            setattr(address, field, value)
        self.db.commit()
        self.db.refresh(address)
        return address

    def delete(self, address: Address) -> bool:
        """Delete address"""
        self.db.delete(address)
        self.db.commit()
        return True
