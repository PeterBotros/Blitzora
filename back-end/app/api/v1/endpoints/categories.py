"""
Category endpoints
"""
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User, UserRole
from app.schemas.category import CategoryResponse, CategoryCreate, CategoryUpdate
from app.services.category_service import CategoryService
from app.core.exceptions import (
    NotFoundError,
    ValidationError,
    not_found_exception,
    validation_exception,
    authorization_exception,
)

router = APIRouter()


@router.get("/", response_model=List[CategoryResponse])
async def get_categories(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Get all categories"""
    service = CategoryService(db)
    return service.get_all_categories(skip, limit)


@router.get("/{category_id}", response_model=CategoryResponse)
async def get_category(
    category_id: str,
    db: Session = Depends(get_db)
):
    """Get category by ID"""
    service = CategoryService(db)
    try:
        return service.get_category_by_id(category_id)
    except NotFoundError as e:
        raise not_found_exception(str(e))


@router.post("/", response_model=CategoryResponse, status_code=status.HTTP_201_CREATED)
async def create_category(
    category_data: CategoryCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Create a new category (Admin-only)"""
    if current_user.role != UserRole.ADMIN.value:
        raise authorization_exception("Only admins can create categories")
    
    service = CategoryService(db)
    try:
        return service.create_category(category_data)
    except ValidationError as e:
        raise validation_exception(str(e))


@router.put("/{category_id}", response_model=CategoryResponse)
async def update_category(
    category_id: str,
    update_data: CategoryUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Update a category (Admin-only)"""
    if current_user.role != UserRole.ADMIN.value:
        raise authorization_exception("Only admins can update categories")

    service = CategoryService(db)
    try:
        return service.update_category(category_id, update_data)
    except NotFoundError as e:
        raise not_found_exception(str(e))
    except ValidationError as e:
        raise validation_exception(str(e))


@router.delete("/{category_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_category(
    category_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Delete a category (Admin-only)"""
    if current_user.role != UserRole.ADMIN.value:
        raise authorization_exception("Only admins can delete categories")

    service = CategoryService(db)
    try:
        service.delete_category(category_id)
        return None
    except NotFoundError as e:
        raise not_found_exception(str(e))
