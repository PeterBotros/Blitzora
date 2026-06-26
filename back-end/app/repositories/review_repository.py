"""
Review repository - data access layer
"""
from sqlalchemy.orm import Session
from typing import List, Optional
from app.models.pharmacy import Review
from app.schemas.review import ReviewCreate


class ReviewRepository:
    """Review repository for database operations"""

    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, review_id: str) -> Optional[Review]:
        """Get review by ID"""
        return self.db.query(Review).filter(Review.id == review_id).first()

    def get_all_by_product_id(self, product_id: str, skip: int = 0, limit: int = 100) -> List[Review]:
        """Get all reviews for a specific product"""
        return (
            self.db.query(Review)
            .filter(Review.product_id == product_id)
            .order_by(Review.created_at.desc())
            .offset(skip)
            .limit(limit)
            .all()
        )

    def get_user_product_review(self, user_id: str, product_id: str) -> Optional[Review]:
        """Check if a user has already reviewed a specific product"""
        return (
            self.db.query(Review)
            .filter(Review.user_id == user_id, Review.product_id == product_id)
            .first()
        )

    def create(self, user_id: str, review_data: ReviewCreate) -> Review:
        """Create a new review"""
        db_review = Review(
            user_id=user_id,
            product_id=review_data.product_id,
            rating=review_data.rating,
            comment=review_data.comment
        )
        self.db.add(db_review)
        self.db.commit()
        self.db.refresh(db_review)
        return db_review

    def delete(self, review: Review) -> bool:
        """Delete a review"""
        self.db.delete(review)
        self.db.commit()
        return True
