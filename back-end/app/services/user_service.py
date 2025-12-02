"""
User service - business logic layer
"""
from sqlalchemy.orm import Session
from typing import Optional, List
from app.repositories.user_repository import UserRepository
from app.schemas.user import UserCreate, UserUpdate, UserResponse
from app.core.exceptions import NotFoundError, ValidationError


class UserService:
    """User service for business logic"""
    
    def __init__(self, db: Session):
        self.repository = UserRepository(db)
    
    def get_user_by_id(self, user_id: int) -> Optional[UserResponse]:
        """Get user by ID"""
        user = self.repository.get_by_id(user_id)
        if not user:
            raise NotFoundError(f"User with ID {user_id} not found")
        return UserResponse.model_validate(user)
    
    def get_user_by_email(self, email: str) -> Optional[UserResponse]:
        """Get user by email"""
        user = self.repository.get_by_email(email)
        if not user:
            return None
        return UserResponse.model_validate(user)
    
    def get_all_users(self, skip: int = 0, limit: int = 100) -> List[UserResponse]:
        """Get all users"""
        users = self.repository.get_all(skip, limit)
        return [UserResponse.model_validate(user) for user in users]
    
    def create_user(self, user_data: UserCreate) -> UserResponse:
        """Create a new user"""
        # Check if user already exists
        if self.repository.get_by_email(user_data.email):
            raise ValidationError("User with this email already exists")
        if self.repository.get_by_username(user_data.username):
            raise ValidationError("User with this username already exists")
        
        user = self.repository.create(user_data)
        return UserResponse.model_validate(user)
    
    def update_user(self, user_id: int, update_data: UserUpdate) -> UserResponse:
        """Update user"""
        user = self.repository.get_by_id(user_id)
        if not user:
            raise NotFoundError(f"User with ID {user_id} not found")
        
        update_dict = update_data.model_dump(exclude_unset=True)
        updated_user = self.repository.update(user, update_dict)
        return UserResponse.model_validate(updated_user)
    
    def delete_user(self, user_id: int) -> bool:
        """Delete user"""
        user = self.repository.get_by_id(user_id)
        if not user:
            raise NotFoundError(f"User with ID {user_id} not found")
        return self.repository.delete(user)

