"""
Pharmacy-related models: pharmacies, inventory, addresses, orders, etc.
"""
from datetime import datetime, time

from sqlalchemy import (
    Boolean,
    CheckConstraint,
    Column,
    DateTime,
    DECIMAL,
    Enum,
    ForeignKey,
    Integer,
    String,
    Text,
    Time,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship

from app.core.database import Base


class Pharmacy(Base):
    """Pharmacy location"""

    __tablename__ = "pharmacies"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    name = Column(String(255), nullable=False)
    address = Column(Text, nullable=True)
    latitude = Column(DECIMAL(10, 7), nullable=True)
    longitude = Column(DECIMAL(10, 7), nullable=True)
    phone = Column(String(32), nullable=True)
    opens_at = Column(Time, nullable=True)
    closes_at = Column(Time, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    inventory_items = relationship(
        "PharmacyInventory", back_populates="pharmacy", cascade="all, delete-orphan"
    )
    orders = relationship("Order", back_populates="pharmacy")


class PharmacyInventory(Base):
    """Stock information for a product in a pharmacy"""

    __tablename__ = "pharmacy_inventory"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    pharmacy_id = Column(
        Integer, ForeignKey("pharmacies.id", ondelete="CASCADE"), nullable=False
    )
    product_id = Column(
        Integer, ForeignKey("products.id", ondelete="CASCADE"), nullable=False
    )
    quantity = Column(Integer, nullable=False, default=0)
    price_override = Column(DECIMAL(10, 2), nullable=True)

    __table_args__ = (
        UniqueConstraint('pharmacy_id', 'product_id', name='uq_inventory_pharmacy_product'),
    )

    pharmacy = relationship("Pharmacy", back_populates="inventory_items")
    product = relationship("Product")


class Profile(Base):
    """Extended user profile"""

    __tablename__ = "profiles"

    id = Column(
        Integer, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True, index=True
    )
    full_name = Column(String(255), nullable=True)
    phone = Column(String(32), unique=True, nullable=True)
    avatar_url = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(
        DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False
    )

    addresses = relationship(
        "Address", back_populates="user", cascade="all, delete-orphan"
    )
    cart = relationship("Cart", back_populates="user", uselist=False)
    orders = relationship("Order", back_populates="user")
    favorites = relationship(
        "Favorite", back_populates="user", cascade="all, delete-orphan"
    )
    reviews = relationship(
        "Review", back_populates="user", cascade="all, delete-orphan"
    )


class Address(Base):
    """User delivery address"""

    __tablename__ = "addresses"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(
        Integer, ForeignKey("profiles.id", ondelete="CASCADE"), nullable=False
    )
    label = Column(String(255), nullable=True)
    street = Column(Text, nullable=True)
    building = Column(Text, nullable=True)
    apartment = Column(Text, nullable=True)
    floor = Column(String(50), nullable=True)
    latitude = Column(DECIMAL(10, 7), nullable=True)
    longitude = Column(DECIMAL(10, 7), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("Profile", back_populates="addresses")
    orders = relationship("Order", back_populates="address")


class Cart(Base):
    """Shopping cart"""

    __tablename__ = "cart"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(
        Integer, ForeignKey("profiles.id", ondelete="CASCADE"), nullable=False, unique=True
    )
    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("Profile", back_populates="cart")
    items = relationship("CartItem", back_populates="cart", cascade="all, delete-orphan")


class CartItem(Base):
    """Item inside a shopping cart"""

    __tablename__ = "cart_items"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    cart_id = Column(Integer, ForeignKey("cart.id", ondelete="CASCADE"), nullable=False)
    product_id = Column(
        Integer, ForeignKey("products.id", ondelete="CASCADE"), nullable=False
    )
    quantity = Column(Integer, nullable=False, default=1)

    __table_args__ = (
        UniqueConstraint('cart_id', 'product_id', name='uq_cart_items_cart_product'),
    )

    cart = relationship("Cart", back_populates="items")
    product = relationship("Product")


class OrderStatusEnum(str):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    SHIPPED = "shipped"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"


class PaymentMethodEnum(str):
    CASH = "cash"
    CARD = "card"


class Order(Base):
    """Customer order"""

    __tablename__ = "orders"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("profiles.id", ondelete="SET NULL"))
    address_id = Column(Integer, ForeignKey("addresses.id", ondelete="SET NULL"))
    pharmacy_id = Column(Integer, ForeignKey("pharmacies.id", ondelete="SET NULL"))
    status = Column(
        Enum(
            OrderStatusEnum.PENDING,
            OrderStatusEnum.CONFIRMED,
            OrderStatusEnum.SHIPPED,
            OrderStatusEnum.DELIVERED,
            OrderStatusEnum.CANCELLED,
            name="order_status_enum",
        ),
        default=OrderStatusEnum.PENDING,
    )
    subtotal = Column(DECIMAL(10, 2), nullable=True)
    discount = Column(DECIMAL(10, 2), nullable=True)
    total = Column(DECIMAL(10, 2), nullable=True)
    payment_method = Column(
        Enum(PaymentMethodEnum.CASH, PaymentMethodEnum.CARD, name="payment_method_enum"),
        nullable=True,
    )
    created_at = Column(DateTime, default=datetime.utcnow)
    delivered_at = Column(DateTime, nullable=True)

    user = relationship("Profile", back_populates="orders")
    pharmacy = relationship("Pharmacy", back_populates="orders")
    address = relationship("Address", back_populates="orders")
    items = relationship("OrderItem", back_populates="order", cascade="all, delete-orphan")


class OrderItem(Base):
    """Item in an order"""

    __tablename__ = "order_items"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    order_id = Column(
        Integer, ForeignKey("orders.id", ondelete="CASCADE"), nullable=False
    )
    product_id = Column(
        Integer, ForeignKey("products.id", ondelete="CASCADE"), nullable=False
    )
    quantity = Column(Integer, nullable=False)
    price = Column(DECIMAL(10, 2), nullable=False)

    order = relationship("Order", back_populates="items")
    product = relationship("Product")


class Favorite(Base):
    """User favorite products"""

    __tablename__ = "favorites"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(
        Integer, ForeignKey("profiles.id", ondelete="CASCADE"), nullable=False
    )
    product_id = Column(
        Integer, ForeignKey("products.id", ondelete="CASCADE"), nullable=False
    )
    created_at = Column(DateTime, default=datetime.utcnow)

    __table_args__ = (
        UniqueConstraint('user_id', 'product_id', name='uq_favorites_user_product'),
    )

    user = relationship("Profile", back_populates="favorites")
    product = relationship("Product")


class Review(Base):
    """Product reviews"""

    __tablename__ = "reviews"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(
        Integer, ForeignKey("profiles.id", ondelete="CASCADE"), nullable=False
    )
    product_id = Column(
        Integer, ForeignKey("products.id", ondelete="CASCADE"), nullable=False
    )
    rating = Column(Integer, nullable=False)
    comment = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    __table_args__ = (
        CheckConstraint('rating BETWEEN 1 AND 5', name='chk_reviews_rating'),
    )

    user = relationship("Profile", back_populates="reviews")
    product = relationship("Product")


