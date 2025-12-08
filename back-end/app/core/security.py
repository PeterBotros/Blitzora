"""
Security utilities (hashing, JWT tokens)
"""
from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from app.core.config import settings

import hashlib
import bcrypt

# Use manual SHA256 + bcrypt to completely avoid the 72-byte limit
# This approach: SHA256(password) -> bcrypt(SHA256_hash)
# SHA256 always produces 64 hex characters, well under bcrypt's 72-byte limit


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a password against a hash
    
    Uses SHA256 pre-hashing + bcrypt to support passwords of any length.
    """
    try:
        # Pre-hash password with SHA256 (always 64 hex chars = 32 bytes)
        sha256_hash = hashlib.sha256(plain_password.encode('utf-8')).hexdigest()
        # Verify the SHA256 hash against the bcrypt hash
        # Convert string hash to bytes for bcrypt
        return bcrypt.checkpw(sha256_hash.encode('utf-8'), hashed_password.encode('utf-8'))
    except Exception as e:
        # Log for debugging
        print(f"Password verification error: {e}")
        return False


def get_password_hash(password: str) -> str:
    """Hash a password using SHA256 + bcrypt (no 72-byte limit)
    
    This approach allows passwords of any length by:
    1. Hashing password with SHA256 (always produces 64 hex chars)
    2. Hashing the SHA256 result with bcrypt (64 chars is well under 72-byte limit)
    """
    # Pre-hash with SHA256 to get fixed-length hash (64 hex characters = 32 bytes)
    sha256_hash = hashlib.sha256(password.encode('utf-8')).hexdigest()
    # Hash the SHA256 result with bcrypt (always safe, 64 chars < 72 bytes)
    # Use bcrypt directly with cost factor 12 (recommended)
    hashed = bcrypt.hashpw(sha256_hash.encode('utf-8'), bcrypt.gensalt(rounds=12))
    # Return as string (bcrypt returns bytes)
    return hashed.decode('utf-8')


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    """Create a JWT access token"""
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt


def decode_access_token(token: str) -> Optional[dict]:
    """Decode and verify a JWT token"""
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        return payload
    except JWTError:
        return None

