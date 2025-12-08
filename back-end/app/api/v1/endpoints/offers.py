"""
Offer endpoints
"""
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.services.offer_service import OfferService
from app.schemas.offer import OfferResponse

router = APIRouter()


@router.get("/", response_model=List[OfferResponse])
async def get_offers(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Get list of all offers"""
    service = OfferService(db)
    return service.get_all_offers(skip, limit)


@router.get("/active/", response_model=List[OfferResponse])
async def get_active_offers(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Get active offers (currently valid)"""
    service = OfferService(db)
    return service.get_active_offers(skip, limit)


@router.get("/global/", response_model=List[OfferResponse])
async def get_global_offers(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Get global offers (not product-specific)"""
    service = OfferService(db)
    return service.get_global_offers(skip, limit)

