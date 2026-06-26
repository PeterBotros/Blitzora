"""
Review endpoints
"""
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User
from app.schemas.review import ReviewResponse, ReviewCreate
from app.services.review_service import ReviewService
from app.core.exceptions import (
    NotFoundError,
    ValidationError,
    not_found_exception,
    validation_exception,
)

router = APIRouter()


@router.post("/", response_model=ReviewResponse, status_code=status.HTTP_201_CREATED)
async def create_review(
    review_data: ReviewCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Submit a review for a product (One review per user per product)"""
    service = ReviewService(db)
    try:
        return service.create_review(current_user.id, review_data)
    except NotFoundError as e:
        raise not_found_exception(str(e))
    except ValidationError as e:
        raise validation_exception(str(e))


@router.get("/product/{id}", response_model=List[ReviewResponse])
async def get_product_reviews(
    id: str,
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Retrieve reviews for a specific product by product ID"""
    service = ReviewService(db)
    try:
        return service.get_product_reviews(id, skip, limit)
    except NotFoundError as e:
        raise not_found_exception(str(e))


@router.delete("/{review_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_review(
    review_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Delete a product review (Admin or Author only)"""
    service = ReviewService(db)
    try:
        service.delete_review(review_id, current_user.id, current_user.role)
        return None
    except NotFoundError as e:
        raise not_found_exception(str(e))
    except ValidationError as e:
        raise validation_exception(str(e))
