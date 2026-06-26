"""
Order repository - data access layer
"""
from sqlalchemy.orm import Session
from typing import Optional, List
from datetime import datetime
from decimal import Decimal
from app.models.pharmacy import Order, OrderItem, Cart, CartItem
from app.models.catalog import Product
from app.schemas.order import OrderCreate, OrderStatus


class OrderRepository:
    """Order repository for database operations"""

    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, order_id: str) -> Optional[Order]:
        """Get order by ID"""
        return self.db.query(Order).filter(Order.id == order_id).first()

    def get_user_order(self, order_id: str, user_id: str) -> Optional[Order]:
        """Get an order with a specific user ID to ensure ownership"""
        return (
            self.db.query(Order)
            .filter(Order.id == order_id, Order.user_id == user_id)
            .first()
        )

    def get_all_by_user_id(self, user_id: str, skip: int = 0, limit: int = 100) -> List[Order]:
        """Get all orders for a user with pagination"""
        return (
            self.db.query(Order)
            .filter(Order.user_id == user_id)
            .order_by(Order.created_at.desc())
            .offset(skip)
            .limit(limit)
            .all()
        )

    def get_all(self, skip: int = 0, limit: int = 100) -> List[Order]:
        """Get all orders globally (for admins)"""
        return (
            self.db.query(Order)
            .order_by(Order.created_at.desc())
            .offset(skip)
            .limit(limit)
            .all()
        )

    def create_order_from_cart(
        self, user_id: str, cart: Cart, order_data: OrderCreate
    ) -> Optional[Order]:
        """
        Creates an Order from a user's current shopping Cart items.
        Automatically calculates totals, generates OrderItems, clears the cart, and returns the Order.
        """
        if not cart.items:
            return None

        subtotal = Decimal("0.00")
        discount = Decimal("0.00")

        # Create the Order base entity first
        db_order = Order(
            user_id=user_id,
            address_id=order_data.address_id,
            pharmacy_id=order_data.pharmacy_id,
            status=OrderStatus.PENDING.value,
            payment_method=order_data.payment_method.value,
        )
        self.db.add(db_order)
        self.db.flush()  # Flush to get the order ID

        # Generate order items and calculate totals
        for item in cart.items:
            product = item.product
            if not product:
                continue

            item_price = product.price
            item_subtotal = item_price * item.quantity
            item_discount = item_subtotal * Decimal(product.discount_percent) / Decimal(100)

            subtotal += item_subtotal
            discount += item_discount

            # Deduct stock if there is stock management
            if product.stock >= item.quantity:
                product.stock -= item.quantity

            db_order_item = OrderItem(
                order_id=db_order.id,
                product_id=item.product_id,
                quantity=item.quantity,
                price=item_price,
            )
            self.db.add(db_order_item)

        total = subtotal - discount

        # Update order amounts
        db_order.subtotal = subtotal
        db_order.discount = discount
        db_order.total = total

        # Clear the user's cart items
        self.db.query(CartItem).filter(CartItem.cart_id == cart.id).delete()

        self.db.commit()
        self.db.refresh(db_order)
        return db_order

    def update_status(self, order: Order, status: OrderStatus) -> Order:
        """Update the status of an order"""
        order.status = status.value
        if status == OrderStatus.DELIVERED:
            order.delivered_at = datetime.utcnow()
        self.db.commit()
        self.db.refresh(order)
        return order
