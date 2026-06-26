"""
Category service - business logic layer
"""
from sqlalchemy.orm import Session
from typing import List, Optional
from app.repositories.category_repository import CategoryRepository
from app.schemas.category import CategoryCreate, CategoryUpdate, CategoryResponse
from app.core.exceptions import NotFoundError, ValidationError


class CategoryService:
    """Category service for business logic"""

    def __init__(self, db: Session):
        self.repository = CategoryRepository(db)

    def get_category_by_id(self, category_id: str) -> CategoryResponse:
        """Get category by ID"""
        category = self.repository.get_by_id(category_id)
        if not category:
            raise NotFoundError(f"Category with ID {category_id} not found")
        return CategoryResponse.model_validate(category)

    def get_all_categories(self, skip: int = 0, limit: int = 100) -> List[CategoryResponse]:
        """Get all categories"""
        categories = self.repository.get_all(skip, limit)
        return [CategoryResponse.model_validate(c) for c in categories]

    def create_category(self, category_data: CategoryCreate) -> CategoryResponse:
        """Create a new category"""
        # Enforce unique category names
        existing = self.repository.get_by_name(category_data.name)
        if existing:
            raise ValidationError(f"Category with name '{category_data.name}' already exists")
        
        category = self.repository.create(category_data)
        return CategoryResponse.model_validate(category)

    def update_category(self, category_id: str, update_data: CategoryUpdate) -> CategoryResponse:
        """Update a category"""
        category = self.repository.get_by_id(category_id)
        if not category:
            raise NotFoundError(f"Category with ID {category_id} not found")

        update_dict = update_data.model_dump(exclude_unset=True)
        
        if "name" in update_dict:
            existing = self.repository.get_by_name(update_dict["name"])
            if existing and existing.id != category_id:
                raise ValidationError(f"Category with name '{update_dict['name']}' already exists")

        updated_category = self.repository.update(category, update_dict)
        return CategoryResponse.model_validate(updated_category)

    def delete_category(self, category_id: str) -> bool:
        """Delete a category"""
        category = self.repository.get_by_id(category_id)
        if not category:
            raise NotFoundError(f"Category with ID {category_id} not found")
        return self.repository.delete(category)
