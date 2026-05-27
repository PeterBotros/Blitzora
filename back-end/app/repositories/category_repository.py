"""
Category repository - data access layer
"""
from sqlalchemy.orm import Session
from typing import Optional, List
from app.models.catalog import Category
from app.schemas.category import CategoryCreate


class CategoryRepository:
    """Category repository for database operations"""

    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, category_id: int) -> Optional[Category]:
        """Get category by ID"""
        return self.db.query(Category).filter(Category.id == category_id).first()

    def get_by_name(self, name: str) -> Optional[Category]:
        """Get category by name"""
        return self.db.query(Category).filter(Category.name == name).first()

    def get_all(self, skip: int = 0, limit: int = 100) -> List[Category]:
        """Get all categories with pagination"""
        return self.db.query(Category).offset(skip).limit(limit).all()

    def create(self, category_data: CategoryCreate) -> Category:
        """Create a new category"""
        db_category = Category(
            name=category_data.name,
            image_url=category_data.image_url
        )
        self.db.add(db_category)
        self.db.commit()
        self.db.refresh(db_category)
        return db_category

    def update(self, category: Category, update_data: dict) -> Category:
        """Update category"""
        for field, value in update_data.items():
            setattr(category, field, value)
        self.db.commit()
        self.db.refresh(category)
        return category

    def delete(self, category: Category) -> bool:
        """Delete category"""
        self.db.delete(category)
        self.db.commit()
        return True
