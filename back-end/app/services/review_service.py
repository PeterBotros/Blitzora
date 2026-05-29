"""
Review service - business logic layer
"""
from sqlalchemy.orm import Session
from typing import List
from app.repositories.review_repository import ReviewRepository
from app.repositories.product_repository import ProductRepository
from app.schemas.review import ReviewCreate, ReviewResponse
from app.models.user import UserRole
from app.core.exceptions import NotFoundError, ValidationError


class ReviewService:
    """Review service for business logic"""

    def __init__(self, db: Session):
        self.repository = ReviewRepository(db)
        self.product_repository = ProductRepository(db)

    def get_product_reviews(self, product_id: int, skip: int = 0, limit: int = 100) -> List[ReviewResponse]:
        """Get all reviews for a specific product"""
        # Validate that the product exists
        product = self.product_repository.get_by_id(product_id)
        if not product:
            raise NotFoundError(f"Product with ID {product_id} not found")

        reviews = self.repository.get_all_by_product_id(product_id, skip, limit)
        return [ReviewResponse.model_validate(r) for r in reviews]

    def create_review(self, user_id: int, review_data: ReviewCreate) -> ReviewResponse:
        """Create a new review for a product"""
        product_id = review_data.product_id
        # Validate product
        product = self.product_repository.get_by_id(product_id)
        if not product:
            raise NotFoundError(f"Product with ID {product_id} not found")

        # Validate unique review per user-product combo
        existing = self.repository.get_user_product_review(user_id, product_id)
        if existing:
            raise ValidationError("You have already reviewed this product. Multiple reviews are not allowed.")

        review = self.repository.create(user_id, review_data)
        return ReviewResponse.model_validate(review)

    def delete_review(self, review_id: int, user_id: int, user_role: str) -> bool:
        """Delete a review (with ownership validation or Admin bypass)"""
        review = self.repository.get_by_id(review_id)
        if not review:
            raise NotFoundError(f"Review with ID {review_id} not found")

        # Admin can delete any review, otherwise user must be the author of the review
        if user_role != UserRole.ADMIN.value and review.user_id != user_id:
            raise ValidationError("You are not authorized to delete this review")

        return self.repository.delete(review)
