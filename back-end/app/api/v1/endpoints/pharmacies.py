"""
Pharmacy endpoints
"""

from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session
from typing import List
from decimal import Decimal

from app.core.database import get_db
from app.services.pharmacy_service import PharmacyService
from app.schemas.pharmacy import (
    PharmacyCreate,
    PharmacyUpdate,
    PharmacyResponse
)
from app.core.exceptions import (
    NotFoundError,
    not_found_exception
)

router = APIRouter(
    tags=["Pharmacies"]
)


# ============================================
# CREATE PHARMACY
# ============================================
@router.post(
    "/",
    response_model=PharmacyResponse,
    status_code=status.HTTP_201_CREATED
)
async def create_pharmacy(
    pharmacy: PharmacyCreate,
    db: Session = Depends(get_db)
):
    """
    Create a new pharmacy
    """

    service = PharmacyService(db)

    return service.create_pharmacy(pharmacy)


# ============================================
# GET ALL PHARMACIES
# ============================================
@router.get(
    "/",
    response_model=List[PharmacyResponse]
)
async def get_pharmacies(
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """
    Get all pharmacies
    """

    service = PharmacyService(db)

    return service.get_all_pharmacies(skip, limit)


# ============================================
# GET NEARBY PHARMACIES
# ============================================
@router.get(
    "/nearby",
    response_model=List[PharmacyResponse]
)
async def get_nearby_pharmacies(
    latitude: Decimal = Query(..., description="User latitude"),
    longitude: Decimal = Query(..., description="User longitude"),
    radius_km: float = Query(
        10.0,
        ge=0.1,
        le=100,
        description="Search radius in KM"
    ),
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """
    Get nearby pharmacies based on coordinates
    """

    service = PharmacyService(db)

    return service.get_nearby_pharmacies(
        latitude=latitude,
        longitude=longitude,
        radius_km=radius_km,
        skip=skip,
        limit=limit
    )


# ============================================
# GET PHARMACY BY ID
# ============================================
@router.get(
    "/{pharmacy_id}",
    response_model=PharmacyResponse
)
async def get_pharmacy(
    pharmacy_id: str,
    db: Session = Depends(get_db)
):
    """
    Get pharmacy by ID
    """

    service = PharmacyService(db)

    try:
        return service.get_pharmacy_by_id(pharmacy_id)

    except NotFoundError as e:
        raise not_found_exception(str(e))


# ============================================
# UPDATE PHARMACY
# ============================================
@router.put(
    "/{pharmacy_id}",
    response_model=PharmacyResponse
)
async def update_pharmacy(
    pharmacy_id: str,
    pharmacy_data: PharmacyUpdate,
    db: Session = Depends(get_db)
):
    """
    Update pharmacy
    """

    service = PharmacyService(db)

    try:
        return service.update_pharmacy(
            pharmacy_id,
            pharmacy_data
        )

    except NotFoundError as e:
        raise not_found_exception(str(e))


# ============================================
# DELETE PHARMACY
# ============================================
@router.delete(
    "/{pharmacy_id}",
    status_code=status.HTTP_204_NO_CONTENT
)
async def delete_pharmacy(
    pharmacy_id: str,
    db: Session = Depends(get_db)
):
    """
    Delete pharmacy
    """

    service = PharmacyService(db)

    try:
        service.delete_pharmacy(pharmacy_id)

    except NotFoundError as e:
        raise not_found_exception(str(e))