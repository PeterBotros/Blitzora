"""
Authentication endpoints
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.core.security import verify_password, create_access_token, decode_access_token
from app.core.dependencies import get_current_user
from app.models.user import User
from app.core.exceptions import authentication_exception, validation_exception
from app.schemas.auth import (
    Token,
    LoginRequest,
    RegisterRequest,
    ForgotPasswordRequest,
    ResetPasswordRequest,
    RefreshTokenRequest,
)
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
            full_name=register_data.full_name,
            phone=register_data.phone
        )
        return service.create_user(user_create)
    except Exception as e:
        raise validation_exception(str(e))


@router.post("/refresh", response_model=Token)
async def refresh(
    refresh_data: RefreshTokenRequest,
    db: Session = Depends(get_db)
):
    """
    Refresh JWT access token
    """
    payload = decode_access_token(refresh_data.refresh_token)
    if not payload or "user_id" not in payload:
        raise authentication_exception("Invalid refresh token")
    
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": payload.get("sub"), "user_id": payload.get("user_id")},
        expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer"
    }


@router.post("/forgot-password")
async def forgot_password(
    request_data: ForgotPasswordRequest,
    db: Session = Depends(get_db)
):
    """
    Forgot password request endpoint
    """
    repository = UserRepository(db)
    user = repository.get_by_email(request_data.email)
    if not user:
        return {"message": "If this email is registered, a password reset link has been sent."}
    
    reset_token = create_access_token(
        data={"user_id": user.id, "purpose": "password_reset"},
        expires_delta=timedelta(minutes=15)
    )
    return {
        "message": "Password reset token generated successfully",
        "reset_token": reset_token
    }


@router.post("/reset-password")
async def reset_password(
    request_data: ResetPasswordRequest,
    db: Session = Depends(get_db)
):
    """
    Reset password using reset token
    """
    payload = decode_access_token(request_data.token)
    if not payload or payload.get("purpose") != "password_reset":
        raise validation_exception("Invalid or expired reset token")
    
    user_id = payload.get("user_id")
    repository = UserRepository(db)
    user = repository.get_by_id(user_id)
    if not user:
        raise validation_exception("User not found")
    
    repository.update(user, {"password": request_data.new_password})
    return {"message": "Password has been reset successfully"}


@router.get("/me", response_model=UserResponse)
async def get_me(
    current_user: User = Depends(get_current_user)
):
    """
    Get currently logged-in user profile
    """
    return UserResponse.model_validate(current_user)
