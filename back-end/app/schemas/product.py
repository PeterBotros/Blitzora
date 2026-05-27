"""
Product schemas
"""
from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
from decimal import Decimal
from app.schemas.category import CategoryResponse


class ProductImageBase(BaseModel):
    """Base product image schema"""
    image_url: str


class ProductImageCreate(ProductImageBase):
    """Product image creation schema"""
    pass


class ProductImageResponse(ProductImageBase):
    """Product image response schema"""
    id: int

    class Config:
        from_attributes = True


class ProductBase(BaseModel):
    """Base product schema"""
    name: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = None
    category_id: Optional[int] = None
    price: Decimal = Field(..., ge=0, description="Price must be non-negative")
    discount_percent: int = Field(0, ge=0, le=100, description="Discount between 0 and 100")
    stock: int = Field(0, ge=0, description="Stock must be non-negative")
    image_url: Optional[str] = None
    is_featured: bool = False


class ProductCreate(ProductBase):
    """Product creation schema"""
    images: List[ProductImageCreate] = []


class ProductUpdate(BaseModel):
    """Product update schema"""
    name: Optional[str] = Field(None, min_length=1, max_length=255)
    description: Optional[str] = None
    category_id: Optional[int] = None
    price: Optional[Decimal] = Field(None, ge=0)
    discount_percent: Optional[int] = Field(None, ge=0, le=100)
    stock: Optional[int] = Field(None, ge=0)
    image_url: Optional[str] = None
    is_featured: Optional[bool] = None
    images: Optional[List[ProductImageCreate]] = None


class ProductResponse(ProductBase):
    """Product response schema"""
    id: int
    created_at: datetime
    category: Optional[CategoryResponse] = None
    images: List[ProductImageResponse] = []

    class Config:
        from_attributes = True


class ProductListResponse(BaseModel):
    """Product list response schema"""
    id: int
    name: str
    description: Optional[str] = None
    category_id: Optional[int] = None
    price: Decimal
    discount_percent: int = 0
    stock: int = 0
    image_url: Optional[str] = None
    is_featured: bool = False
    created_at: datetime

    class Config:
        from_attributes = True
