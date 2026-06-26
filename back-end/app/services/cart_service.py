"""
Cart service - business logic layer
"""
from sqlalchemy.orm import Session
from app.repositories.cart_repository import CartRepository
from app.repositories.product_repository import ProductRepository
from app.schemas.cart import CartResponse, CartItemResponse, CartItemCreate, CartItemUpdate
from app.core.exceptions import NotFoundError, ValidationError


class CartService:
    """Cart service for business logic"""

    def __init__(self, db: Session):
        self.repository = CartRepository(db)
        self.product_repository = ProductRepository(db)

    def get_user_cart(self, user_id: str) -> CartResponse:
        """Get or initialize the user's cart"""
        cart = self.repository.get_by_user_id(user_id)
        return CartResponse.model_validate(cart)

    def add_item_to_cart(self, user_id: str, item_data: CartItemCreate) -> CartItemResponse:
        """Add a product to the user's cart with stock validation"""
        product = self.product_repository.get_by_id(item_data.product_id)
        if not product:
            raise NotFoundError(f"Product with ID {item_data.product_id} not found")

        # Validate stock
        cart = self.repository.get_by_user_id(user_id)
        existing_item = next((item for item in cart.items if item.product_id == item_data.product_id), None)
        requested_qty = item_data.quantity
        if existing_item:
            requested_qty += existing_item.quantity

        if product.stock < requested_qty:
            raise ValidationError(
                f"Insufficient stock for product '{product.name}'. Available: {product.stock}, Requested: {requested_qty}"
            )

        cart_item = self.repository.add_item(
            cart_id=cart.id,
            product_id=item_data.product_id,
            quantity=item_data.quantity
        )
        return CartItemResponse.model_validate(cart_item)

    def update_cart_item(self, user_id: str, product_id: str, update_data: CartItemUpdate) -> CartItemResponse:
        """Update cart item quantity with stock validation"""
        product = self.product_repository.get_by_id(product_id)
        if not product:
            raise NotFoundError(f"Product with ID {product_id} not found")

        if product.stock < update_data.quantity:
            raise ValidationError(
                f"Insufficient stock for product '{product.name}'. Available: {product.stock}, Requested: {update_data.quantity}"
            )

        cart = self.repository.get_by_user_id(user_id)
        cart_item = self.repository.update_item_quantity(
            cart_id=cart.id,
            product_id=product_id,
            quantity=update_data.quantity
        )
        if not cart_item:
            raise NotFoundError(f"Product with ID {product_id} is not in your cart")

        return CartItemResponse.model_validate(cart_item)

    def remove_cart_item(self, user_id: str, product_id: str) -> bool:
        """Remove product from user's cart"""
        cart = self.repository.get_by_user_id(user_id)
        removed = self.repository.remove_item(cart_id=cart.id, product_id=product_id)
        if not removed:
            raise NotFoundError(f"Product with ID {product_id} is not in your cart")
        return True

    def clear_user_cart(self, user_id: str) -> bool:
        """Clear user's cart"""
        cart = self.repository.get_by_user_id(user_id)
        return self.repository.clear_cart(cart_id=cart.id)
