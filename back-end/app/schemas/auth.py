"""
Authentication schemas
"""
from pydantic import BaseModel, EmailStr, Field
from typing import Optional


class LoginRequest(BaseModel):
    """Login request schema"""
    email: EmailStr
    password: str = Field(..., min_length=8, max_length=128, description="Password (8-128 characters)")


class RegisterRequest(BaseModel):
    """Registration request schema"""
    email: EmailStr
    username: str = Field(..., min_length=3, max_length=100)
    password: str = Field(..., min_length=8, max_length=128, description="Password (8-128 characters)")
    full_name: str = Field(..., min_length=3, max_length=100)
    phone: str = Field(..., min_length=3, max_length=100)


class Token(BaseModel):
    """Token response schema"""
    access_token: str
    token_type: str


class TokenData(BaseModel):
    """Token data schema"""
    email: str | None = None


class ForgotPasswordRequest(BaseModel):
    """Forgot password request schema"""
    email: EmailStr


class ResetPasswordRequest(BaseModel):
    """Reset password request schema"""
    token: str
    new_password: str = Field(..., min_length=8, max_length=128, description="New password (8-128 characters)")


class RefreshTokenRequest(BaseModel):
    """Refresh token request schema"""
    refresh_token: str


