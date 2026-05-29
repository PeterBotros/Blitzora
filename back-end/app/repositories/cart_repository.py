"""
Cart repository - data access layer
"""
from sqlalchemy.orm import Session
from typing import Optional
from app.models.pharmacy import Cart, CartItem
from app.models.catalog import Product


class CartRepository:
    """Cart repository for database operations"""

    def __init__(self, db: Session):
        self.db = db

    def get_by_user_id(self, user_id: int) -> Cart:
        """
        Get or create a cart for the user.
        Ensures a user always has a cart record ready.
        """
        cart = self.db.query(Cart).filter(Cart.user_id == user_id).first()
        if not cart:
            cart = Cart(user_id=user_id)
            self.db.add(cart)
            self.db.commit()
            self.db.refresh(cart)
        return cart

    def add_item(self, cart_id: int, product_id: int, quantity: int = 1) -> CartItem:
        """Add or update quantity of product in cart"""
        cart_item = (
            self.db.query(CartItem)
            .filter(CartItem.cart_id == cart_id, CartItem.product_id == product_id)
            .first()
        )
        if cart_item:
            cart_item.quantity += quantity
        else:
            cart_item = CartItem(cart_id=cart_id, product_id=product_id, quantity=quantity)
            self.db.add(cart_item)
        
        self.db.commit()
        self.db.refresh(cart_item)
        return cart_item

    def update_item_quantity(self, cart_id: int, product_id: int, quantity: int) -> Optional[CartItem]:
        """Update the quantity of a product in the cart"""
        cart_item = (
            self.db.query(CartItem)
            .filter(CartItem.cart_id == cart_id, CartItem.product_id == product_id)
            .first()
        )
        if cart_item:
            cart_item.quantity = quantity
            self.db.commit()
            self.db.refresh(cart_item)
        return cart_item

    def remove_item(self, cart_id: int, product_id: int) -> bool:
        """Remove a product from the cart"""
        cart_item = (
            self.db.query(CartItem)
            .filter(CartItem.cart_id == cart_id, CartItem.product_id == product_id)
            .first()
        )
        if cart_item:
            self.db.delete(cart_item)
            self.db.commit()
            return True
        return False

    def clear_cart(self, cart_id: int) -> bool:
        """Delete all items in the cart"""
        self.db.query(CartItem).filter(CartItem.cart_id == cart_id).delete()
        self.db.commit()
        return True
