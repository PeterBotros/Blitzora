"""
Favorite endpoints
"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User
from app.schemas.favorite import FavoriteResponse
from app.services.favorite_service import FavoriteService
from app.core.exceptions import (
    NotFoundError,
    ValidationError,
    not_found_exception,
    validation_exception,
)

router = APIRouter()


@router.get("/", response_model=List[FavoriteResponse])
async def get_favorites(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Retrieve all favorited products for the authenticated user"""
    service = FavoriteService(db)
    return service.get_my_favorites(current_user.id)


@router.post("/{product_id}", response_model=FavoriteResponse, status_code=status.HTTP_201_CREATED)
async def add_favorite(
    product_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Add a product to user's favorites"""
    service = FavoriteService(db)
    try:
        return service.add_favorite(current_user.id, product_id)
    except NotFoundError as e:
        raise not_found_exception(str(e))
    except ValidationError as e:
        raise validation_exception(str(e))


@router.delete("/{product_id}", status_code=status.HTTP_204_NO_CONTENT)
async def remove_favorite(
    product_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Remove a product from user's favorites"""
    service = FavoriteService(db)
    try:
        service.remove_favorite(current_user.id, product_id)
        return None
    except NotFoundError as e:
        raise not_found_exception(str(e))
