"""
Address endpoints
"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User
from app.schemas.address import AddressResponse, AddressCreate, AddressUpdate
from app.services.address_service import AddressService
from app.core.exceptions import (
    NotFoundError,
    not_found_exception,
)

router = APIRouter()


@router.get("/", response_model=List[AddressResponse])
async def get_addresses(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Retrieve all delivery addresses for the authenticated user"""
    service = AddressService(db)
    return service.get_all_user_addresses(current_user.id)


@router.get("/{address_id}", response_model=AddressResponse)
async def get_address(
    address_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Retrieve a specific delivery address by ID"""
    service = AddressService(db)
    try:
        return service.get_address_by_id(address_id, current_user.id)
    except NotFoundError as e:
        raise not_found_exception(str(e))


@router.post("/", response_model=AddressResponse, status_code=status.HTTP_201_CREATED)
async def create_address(
    address_data: AddressCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Create a new delivery address"""
    service = AddressService(db)
    return service.create_address(current_user.id, address_data)


@router.put("/{address_id}", response_model=AddressResponse)
async def update_address(
    address_id: int,
    update_data: AddressUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Update details of a delivery address"""
    service = AddressService(db)
    try:
        return service.update_address(address_id, current_user.id, update_data)
    except NotFoundError as e:
        raise not_found_exception(str(e))


@router.delete("/{address_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_address(
    address_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Delete a delivery address"""
    service = AddressService(db)
    try:
        service.delete_address(address_id, current_user.id)
        return None
    except NotFoundError as e:
        raise not_found_exception(str(e))
