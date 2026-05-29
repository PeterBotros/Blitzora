"""
Address service - business logic layer
"""
from sqlalchemy.orm import Session
from typing import List
from app.repositories.address_repository import AddressRepository
from app.schemas.address import AddressCreate, AddressUpdate, AddressResponse
from app.core.exceptions import NotFoundError


class AddressService:
    """Address service for business logic"""

    def __init__(self, db: Session):
        self.repository = AddressRepository(db)

    def get_address_by_id(self, address_id: int, user_id: int) -> AddressResponse:
        """Get user's address by ID (with ownership validation)"""
        address = self.repository.get_user_address(address_id, user_id)
        if not address:
            raise NotFoundError(f"Address with ID {address_id} not found")
        return AddressResponse.model_validate(address)

    def get_all_user_addresses(self, user_id: int) -> List[AddressResponse]:
        """Get all delivery addresses for a user"""
        addresses = self.repository.get_all_by_user_id(user_id)
        return [AddressResponse.model_validate(a) for a in addresses]

    def create_address(self, user_id: int, address_data: AddressCreate) -> AddressResponse:
        """Create a new delivery address for the user"""
        address = self.repository.create(user_id, address_data)
        return AddressResponse.model_validate(address)

    def update_address(self, address_id: int, user_id: int, update_data: AddressUpdate) -> AddressResponse:
        """Update a user's address (with ownership validation)"""
        address = self.repository.get_user_address(address_id, user_id)
        if not address:
            raise NotFoundError(f"Address with ID {address_id} not found")

        update_dict = update_data.model_dump(exclude_unset=True)
        updated_address = self.repository.update(address, update_dict)
        return AddressResponse.model_validate(updated_address)

    def delete_address(self, address_id: int, user_id: int) -> bool:
        """Delete a user's address (with ownership validation)"""
        address = self.repository.get_user_address(address_id, user_id)
        if not address:
            raise NotFoundError(f"Address with ID {address_id} not found")
        return self.repository.delete(address)
