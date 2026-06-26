"""
Favorite service - business logic layer
"""
from sqlalchemy.orm import Session
from typing import List
from app.repositories.favorite_repository import FavoriteRepository
from app.repositories.product_repository import ProductRepository
from app.schemas.favorite import FavoriteResponse
from app.core.exceptions import NotFoundError, ValidationError


class FavoriteService:
    """Favorite service for business logic"""

    def __init__(self, db: Session):
        self.repository = FavoriteRepository(db)
        self.product_repository = ProductRepository(db)

    def get_my_favorites(self, user_id: str) -> List[FavoriteResponse]:
        """Get all favorites for the authenticated user"""
        favorites = self.repository.get_all_by_user_id(user_id)
        return [FavoriteResponse.model_validate(f) for f in favorites]

    def add_favorite(self, user_id: str, product_id: str) -> FavoriteResponse:
        """Add product to user's favorites"""
        # Validate that the product exists
        product = self.product_repository.get_by_id(product_id)
        if not product:
            raise NotFoundError(f"Product with ID {product_id} not found")

        # Check if already favorited
        existing = self.repository.get_by_user_and_product(user_id, product_id)
        if existing:
            raise ValidationError("Product is already in your favorites")

        favorite = self.repository.create(user_id, product_id)
        return FavoriteResponse.model_validate(favorite)

    def remove_favorite(self, user_id: str, product_id: str) -> bool:
        """Remove product from user's favorites"""
        favorite = self.repository.get_by_user_and_product(user_id, product_id)
        if not favorite:
            raise NotFoundError(f"Product with ID {product_id} is not in your favorites")
        return self.repository.delete(favorite)
