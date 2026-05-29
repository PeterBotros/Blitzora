"""
Favorite repository - data access layer
"""
from sqlalchemy.orm import Session
from typing import List, Optional
from app.models.pharmacy import Favorite


class FavoriteRepository:
    """Favorite repository for database operations"""

    def __init__(self, db: Session):
        self.db = db

    def get_by_user_and_product(self, user_id: int, product_id: int) -> Optional[Favorite]:
        """Check if a favorite exists for a user and product"""
        return (
            self.db.query(Favorite)
            .filter(Favorite.user_id == user_id, Favorite.product_id == product_id)
            .first()
        )

    def get_all_by_user_id(self, user_id: int) -> List[Favorite]:
        """Get all favorites for a user"""
        return self.db.query(Favorite).filter(Favorite.user_id == user_id).all()

    def create(self, user_id: int, product_id: int) -> Favorite:
        """Add product to user's favorites"""
        db_favorite = Favorite(user_id=user_id, product_id=product_id)
        self.db.add(db_favorite)
        self.db.commit()
        self.db.refresh(db_favorite)
        return db_favorite

    def delete(self, favorite: Favorite) -> bool:
        """Remove a product from user's favorites"""
        self.db.delete(favorite)
        self.db.commit()
        return True
