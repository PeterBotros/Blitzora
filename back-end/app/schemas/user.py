"""
User schemas
"""
from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime
from app.models.user import UserRole


class UserBase(BaseModel):
    """Base user schema"""
    email: EmailStr
    username: str
    full_name: Optional[str] = None
    phone: Optional[str] = None


class UserCreate(UserBase):
    """User creation schema"""
    password: str = Field(..., min_length=8, max_length=128, description="Password (8-128 characters)")
    phone: Optional[str] = None


class UserUpdate(BaseModel):
    """User update schema (admin use - allows role/is_active changes)"""
    email: Optional[EmailStr] = None
    username: Optional[str] = None
    full_name: Optional[str] = None
    phone: Optional[str] = None
    password: Optional[str] = Field(None, min_length=8, max_length=128, description="Password (8-128 characters)")
    role: Optional[UserRole] = None
    is_active: Optional[bool] = None


class UserSelfUpdate(BaseModel):
    """Self-service profile update schema (no role/is_active changes allowed)"""
    email: Optional[EmailStr] = None
    username: Optional[str] = None
    full_name: Optional[str] = None
    phone: Optional[str] = None
    password: Optional[str] = Field(None, min_length=8, max_length=128, description="Password (8-128 characters)")


class UserResponse(UserBase):
    """User response schema"""
    id: str
    role: UserRole = UserRole.USER
    is_active: bool
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
    orders_count: int = 0
    favorites_count: int = 0

    class Config:
        from_attributes = True