"""
Pharmacy endpoints
"""
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from decimal import Decimal
from app.core.database import get_db
from app.services.pharmacy_service import PharmacyService
from app.schemas.pharmacy import PharmacyResponse
from app.core.exceptions import NotFoundError, not_found_exception

router = APIRouter()

@router.post("/", response_model=PharmacyResponse)
async def create_pharmacy(
    pharmacy: PharmacyResponse,
    db: Session = Depends(get_db)
):
    """Create a new pharmacy"""
    service = PharmacyService(db)
    return service.create_pharmacy(pharmacy)

@router.get("/", response_model=List[PharmacyResponse])
async def get_pharmacies(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Get list of pharmacies"""
    try:
        service = PharmacyService(db)
        return service.get_all_pharmacies(skip, limit)
    except Exception as e:
        import traceback
        error_details = traceback.format_exc()
        print("=" * 50)
        print("ERROR IN GET_PHARMACIES:")
        print(error_details)
        print("=" * 50)
        from fastapi import HTTPException
        raise HTTPException(
            status_code=500,
            detail=f"Error: {str(e)}. Check server logs for details."
        )


@router.get("/nearby", response_model=List[PharmacyResponse])
async def get_nearby_pharmacies(
    latitude: Decimal = Query(..., description="Latitude coordinate"),
    longitude: Decimal = Query(..., description="Longitude coordinate"),
    radius_km: float = Query(10.0, ge=0.1, le=100, description="Search radius in kilometers"),
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Get nearby pharmacies"""
    service = PharmacyService(db)
    return service.get_nearby_pharmacies(latitude, longitude, radius_km, skip, limit)


@router.get("/{pharmacy_id}", response_model=PharmacyResponse)
async def get_pharmacy(
    pharmacy_id: int,
    db: Session = Depends(get_db)
):
    """Get pharmacy by ID"""
    service = PharmacyService(db)
    try:
        return service.get_pharmacy_by_id(pharmacy_id)
    except NotFoundError as e:
        raise not_found_exception(str(e))

