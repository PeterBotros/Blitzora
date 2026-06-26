"""
Order service - business logic layer
"""
from sqlalchemy.orm import Session
from typing import List, Optional
from app.repositories.order_repository import OrderRepository
from app.repositories.cart_repository import CartRepository
from app.repositories.address_repository import AddressRepository
from app.schemas.order import OrderCreate, OrderStatusUpdate, OrderResponse, OrderStatus
from app.models.user import UserRole
from app.core.exceptions import NotFoundError, ValidationError


class OrderService:
    """Order service for business logic"""

    def __init__(self, db: Session):
        self.repository = OrderRepository(db)
        self.cart_repository = CartRepository(db)
        self.address_repository = AddressRepository(db)

    def place_order(self, user_id: str, order_data: OrderCreate) -> OrderResponse:
        """Place an order from the user's current shopping cart"""
        # Validate that the address belongs to the user
        address = self.address_repository.get_user_address(order_data.address_id, user_id)
        if not address:
            raise ValidationError("Invalid address selected for delivery")

        # Get user cart
        cart = self.cart_repository.get_by_user_id(user_id)
        if not cart.items:
            raise ValidationError("Cannot place order. Your shopping cart is empty")

        # Place the order
        order = self.repository.create_order_from_cart(user_id, cart, order_data)
        if not order:
            raise ValidationError("Failed to place order. Please check product stock levels")

        return OrderResponse.model_validate(order)

    def get_order_details(self, order_id: str, user_id: str, user_role: str) -> OrderResponse:
        """Get details of a specific order (with ownership and role validation)"""
        # Admin and staff can see any order, users can only see their own
        if user_role in [UserRole.ADMIN.value, UserRole.PHARMACY_STAFF.value]:
            order = self.repository.get_by_id(order_id)
        else:
            order = self.repository.get_user_order(order_id, user_id)

        if not order:
            raise NotFoundError(f"Order with ID {order_id} not found")
        return OrderResponse.model_validate(order)

    def get_my_orders(self, user_id: str, skip: int = 0, limit: int = 100) -> List[OrderResponse]:
        """Get the order history for the authenticated user"""
        orders = self.repository.get_all_by_user_id(user_id, skip, limit)
        return [OrderResponse.model_validate(o) for o in orders]

    def get_all_orders_admin(self, skip: int = 0, limit: int = 100) -> List[OrderResponse]:
        """Get all orders globally (for admins and pharmacy staff)"""
        orders = self.repository.get_all(skip, limit)
        return [OrderResponse.model_validate(o) for o in orders]

    def update_status(self, order_id: str, status_data: OrderStatusUpdate) -> OrderResponse:
        """Update an order's status (for admins and staff)"""
        order = self.repository.get_by_id(order_id)
        if not order:
            raise NotFoundError(f"Order with ID {order_id} not found")

        updated_order = self.repository.update_status(order, status_data.status)
        return OrderResponse.model_validate(updated_order)
