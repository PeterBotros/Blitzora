"""
User endpoints
"""
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.schemas.user import UserResponse, UserCreate
from app.models.user import User
from app.core.exceptions import not_found_exception

router = APIRouter()


@router.get("/", response_model=List[UserResponse])
async def get_users(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """
    Get list of users
    """
    # TODO: Implement actual user retrieval
    # users = db.query(User).offset(skip).limit(limit).all()
    # return users
    return []


@router.get("/{user_id}", response_model=UserResponse)
async def get_user(
    user_id: int,
    db: Session = Depends(get_db)
):
    """
    Get user by ID
    """
    # TODO: Implement actual user retrieval
    # user = db.query(User).filter(User.id == user_id).first()
    # if not user:
    #     raise not_found_exception(f"User with ID {user_id} not found")
    # return user
    raise not_found_exception(f"User with ID {user_id} not found")


@router.post("/", response_model=UserResponse)
async def create_user(
    user_data: UserCreate,
    db: Session = Depends(get_db)
):
    """
    Create a new user
    """
    # TODO: Implement user creation
    # user = User(**user_data.dict())
    # db.add(user)
    # db.commit()
    # db.refresh(user)
    # return user
    return {"message": "User creation endpoint - to be implemented"}

