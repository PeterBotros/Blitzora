"""
User repository - data access layer
"""
from sqlalchemy.orm import Session
from typing import Optional, List
from app.models.user import User
from app.schemas.user import UserCreate
from app.core.security import get_password_hash


class UserRepository:
    """User repository for database operations"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_by_id(self, user_id: str) -> Optional[User]:
        """Get user by ID"""
        return self.db.query(User).filter(User.id == user_id).first()
    
    def get_by_email(self, email: str) -> Optional[User]:
        """Get user by email"""
        return self.db.query(User).filter(User.email == email).first()
    
    def get_by_username(self, username: str) -> Optional[User]:
        """Get user by username"""
        return self.db.query(User).filter(User.username == username).first()

    def get_by_email_or_username(self, identifier: str) -> Optional[User]:
        """
        Get user by email or username.
        The identifier is matched against both fields to allow flexible login.
        """
        return (
            self.db.query(User)
            .filter((User.email == identifier) | (User.username == identifier))
            .first()
        )
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[User]:
        """Get all users with pagination"""
        return self.db.query(User).offset(skip).limit(limit).all()
    
    def create(self, user_data: UserCreate) -> User:
        """Create a new user and their associated Profile record"""
        from app.models.user import UserRole
        from app.models.pharmacy import Profile
        from datetime import datetime
        hashed_password = get_password_hash(user_data.password)
        db_user = User(
            email=user_data.email,
            username=user_data.username,
            full_name=user_data.full_name,
            phone=user_data.phone,
            hashed_password=hashed_password,
            role=UserRole.USER.value  # Explicitly set default role as string value
        )
        self.db.add(db_user)
        self.db.flush()  # Flush to generate db_user.id without committing

        # Create a linked Profile record with only the supported fields.
        # The profile table is a 1:1 extension of users and does not store
        # `full_name` or `phone`.
        db_profile = Profile(
            id=db_user.id,
        )
        self.db.add(db_profile)
        self.db.commit()
        self.db.refresh(db_user)
        return db_user
    
    def update(self, user: User, update_data: dict) -> User:
        """Update user"""
        for field, value in update_data.items():
            if field == "password":
                setattr(user, "hashed_password", get_password_hash(value))
            else:
                setattr(user, field, value)
        self.db.commit()
        self.db.refresh(user)
        return user
    
    def delete(self, user: User) -> bool:
        """Delete user"""
        self.db.delete(user)
        self.db.commit()
        return True

