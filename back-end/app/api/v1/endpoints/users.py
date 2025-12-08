"""
User endpoints
"""
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.schemas.user import UserResponse, UserCreate
from app.services.user_service import UserService
from app.core.exceptions import NotFoundError, not_found_exception

router = APIRouter()


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
    user_id: int,
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

