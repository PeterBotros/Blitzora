"""
User endpoints
"""
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User
from app.schemas.user import UserResponse, UserCreate, UserSelfUpdate
from app.services.user_service import UserService
from app.core.exceptions import NotFoundError, not_found_exception, ValidationError, validation_exception

router = APIRouter()


@router.get("/me", response_model=UserResponse)
async def get_my_profile(
    current_user: User = Depends(get_current_user),
):
    """
    Get the currently authenticated user's profile
    """
    return current_user


@router.patch("/me", response_model=UserResponse)
async def update_my_profile(
    update_data: UserSelfUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Update the currently authenticated user's profile
    """
    service = UserService(db)
    try:
        return service.update_user(current_user.id, update_data)
    except NotFoundError as e:
        raise not_found_exception(str(e))
    except ValidationError as e:
        raise validation_exception(str(e))


@router.get("/", response_model=List[UserResponse])
async def get_users(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db)
):
    """
    Get list of users
    """
    service = UserService(db)
    return service.get_all_users(skip, limit)


@router.get("/{user_id}", response_model=UserResponse)
async def get_user(
    user_id: str,
    db: Session = Depends(get_db)
):
    """
    Get user by ID
    """
    service = UserService(db)
    try:
        return service.get_user_by_id(user_id)
    except NotFoundError as e:
        raise not_found_exception(str(e))

@router.delete("/{user_id}", response_model=UserResponse)
async def delete_user(
    user_id: str,
    db: Session = Depends(get_db)
):
    """
    Delete user by ID
    """
    service = UserService(db)
    try:
        return service.delete_user(user_id)
    except NotFoundError as e:
        raise not_found_exception(str(e))