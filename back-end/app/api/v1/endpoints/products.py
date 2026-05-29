"""
Product endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from typing import List, Optional
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User, UserRole
from app.services.product_service import ProductService, CategoryService
from app.schemas.product import ProductResponse, ProductListResponse, ProductCreate, ProductUpdate
from app.schemas.category import CategoryResponse
from app.core.exceptions import (
    NotFoundError,
    ValidationError,
    not_found_exception,
    validation_exception,
    authorization_exception,
)

router = APIRouter()


@router.get("/", response_model=List[ProductListResponse])
async def get_products(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    category_id: Optional[int] = Query(None),
    is_featured: Optional[bool] = Query(None),
    search: Optional[str] = Query(None, description="Search products by name"),
    sort_by: Optional[str] = Query(None, description="Sort options: price_asc, price_desc, name_asc, name_desc, newest"),
    db: Session = Depends(get_db)
):
    """Get list of products with pagination, filters, search, and sorting"""
    service = ProductService(db)
    return service.get_all_products(skip, limit, category_id, is_featured, search, sort_by)


@router.get("/{id}", response_model=ProductResponse)
async def get_product(
    id: int,
    db: Session = Depends(get_db)
):
    """Get product by ID"""
    service = ProductService(db)
    try:
        return service.get_product_by_id(id)
    except NotFoundError as e:
        raise not_found_exception(str(e))


@router.post("/", response_model=ProductResponse, status_code=status.HTTP_201_CREATED)
async def create_product(
    product_data: ProductCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Create a new product (Admin-only)"""
    if current_user.role != UserRole.ADMIN.value:
        raise authorization_exception("Only admins can create products")
    
    service = ProductService(db)
    return service.create_product(product_data)


@router.put("/{id}", response_model=ProductResponse)
async def update_product(
    id: int,
    update_data: ProductUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Update a product by ID (Admin-only)"""
    if current_user.role != UserRole.ADMIN.value:
        raise authorization_exception("Only admins can update products")
    
    service = ProductService(db)
    try:
        return service.update_product(id, update_data)
    except NotFoundError as e:
        raise not_found_exception(str(e))


@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_product(
    id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Delete a product by ID (Admin-only)"""
    if current_user.role != UserRole.ADMIN.value:
        raise authorization_exception("Only admins can delete products")
    
    service = ProductService(db)
    try:
        service.delete_product(id)
        return None
    except NotFoundError as e:
        raise not_found_exception(str(e))
