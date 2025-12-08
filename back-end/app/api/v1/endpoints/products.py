"""
Product endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from app.core.database import get_db
from app.services.product_service import ProductService, CategoryService
from app.schemas.product import ProductResponse, ProductListResponse
from app.schemas.category import CategoryResponse
from app.core.exceptions import NotFoundError, not_found_exception

router = APIRouter()


@router.get("/", response_model=List[ProductListResponse])
async def get_products(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    category_id: Optional[int] = Query(None),
    is_featured: Optional[bool] = Query(None),
    db: Session = Depends(get_db)
):
    """Get list of products"""
    service = ProductService(db)
    return service.get_all_products(skip, limit, category_id, is_featured)


@router.get("/{product_id}", response_model=ProductResponse)
async def get_product(
    product_id: int,
    db: Session = Depends(get_db)
):
    """Get product by ID"""
    service = ProductService(db)
    try:
        return service.get_product_by_id(product_id)
    except NotFoundError as e:
        raise not_found_exception(str(e))


@router.get("/search/{search_term}", response_model=List[ProductListResponse])
async def search_products(
    search_term: str,
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Search products by name"""
    service = ProductService(db)
    return service.search_products(search_term, skip, limit)


@router.get("/categories/", response_model=List[CategoryResponse])
async def get_categories(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """Get list of categories"""
    service = CategoryService(db)
    return service.get_all_categories(skip, limit)


@router.get("/categories/{category_id}", response_model=CategoryResponse)
async def get_category(
    category_id: int,
    db: Session = Depends(get_db)
):
    """Get category by ID"""
    service = CategoryService(db)
    try:
        return service.get_category_by_id(category_id)
    except NotFoundError as e:
        raise not_found_exception(str(e))

