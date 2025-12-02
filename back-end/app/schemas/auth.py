"""
Authentication schemas
"""
from pydantic import BaseModel, EmailStr


class LoginRequest(BaseModel):
    """Login request schema"""
    email: EmailStr
    password: str


class Token(BaseModel):
    """Token response schema"""
    access_token: str
    token_type: str


class TokenData(BaseModel):
    """Token data schema"""
    email: str | None = None

