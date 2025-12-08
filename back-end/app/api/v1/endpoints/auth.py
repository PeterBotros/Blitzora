"""
Authentication endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.core.security import verify_password, create_access_token
from app.core.exceptions import authentication_exception, validation_exception
from app.schemas.auth import Token, LoginRequest, RegisterRequest
from app.schemas.user import UserResponse, UserCreate
from app.repositories.user_repository import UserRepository
from app.services.user_service import UserService
from datetime import timedelta
from app.core.config import settings

router = APIRouter()


@router.post("/login", response_model=Token)
async def login(
    login_data: LoginRequest,
    db: Session = Depends(get_db)
):
    """
    User login endpoint
    
    Authenticates a user with email and password, returns JWT access token.
    """
    repository = UserRepository(db)

    identifier = login_data.email.strip().lower()
    user = repository.get_by_email_or_username(identifier)

    if not user or not verify_password(login_data.password, user.hashed_password):
        raise authentication_exception("Incorrect email/username or password")
    
    if not user.is_active:
        raise authentication_exception("User account is inactive")
    
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.email, "user_id": user.id},
        expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer"
    }


@router.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def register(
    register_data: RegisterRequest,
    db: Session = Depends(get_db)
):
    """
    User registration endpoint
    
    Creates a new user account with email, username, and password.
    """
    service = UserService(db)
    
    try:
        user_create = UserCreate(
            email=register_data.email,
            username=register_data.username,
            password=register_data.password,
            full_name=register_data.full_name
        )
        return service.create_user(user_create)
    except Exception as e:
        raise validation_exception(str(e))

