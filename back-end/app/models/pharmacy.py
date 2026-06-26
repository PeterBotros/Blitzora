"""
Pharmacy-related models: pharmacies, inventory, profile, addresses, orders, etc.
All FK user_id references point to users.id — matching the actual PostgreSQL schema.

All primary keys are string UUIDs, auto-generated via generate_uuid() on insert.
"""
from datetime import datetime, date
from sqlalchemy import (
    Boolean,
    CheckConstraint,
    Column,
    Date,
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
from app.core.utils import generate_uuid


# ---------------------------------------------------------------------------
# Profile (1-to-1 extension of users — FK = users.id)
# Matches actual DB: full_name, phone, avatar_url, created_at, updated_at
# ---------------------------------------------------------------------------
class Profile(Base):
    """Extended user profile — supplementary data only."""
    __tablename__ = "profiles"

    # Shares its primary key with the owning user, so no default generator here.
    id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    full_name = Column(String(255), nullable=True)
    phone = Column(String(32), unique=True, nullable=True)
    avatar_url = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship("User", back_populates="profile")


# ---------------------------------------------------------------------------
# Pharmacy
# ---------------------------------------------------------------------------
class Pharmacy(Base):
    """Pharmacy location"""
    __tablename__ = "pharmacies"

    id = Column(String(36), primary_key=True, index=True, default=generate_uuid)
    name = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    address = Column(Text, nullable=True)
    city = Column(String(100), nullable=True)
    governorate = Column(String(100), nullable=True)
    latitude = Column(DECIMAL(10, 7), nullable=True)
    longitude = Column(DECIMAL(10, 7), nullable=True)
    phone = Column(String(32), nullable=True)
    email = Column(String(255), nullable=True)
    logo_url = Column(Text, nullable=True)
    opens_at = Column(Time, nullable=True)
    closes_at = Column(Time, nullable=True)
    delivery_available = Column(Boolean, default=True)
    rating = Column(DECIMAL(3, 2), default=0)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    inventory_items = relationship("PharmacyInventory", back_populates="pharmacy", cascade="all, delete-orphan")
    orders = relationship("Order", back_populates="pharmacy")


# ---------------------------------------------------------------------------
# PharmacyInventory
# ---------------------------------------------------------------------------
class PharmacyInventory(Base):
    """Stock information for a product in a pharmacy"""
    __tablename__ = "pharmacy_inventory"

    id = Column(String(36), primary_key=True, index=True, default=generate_uuid)
    pharmacy_id = Column(String(36), ForeignKey("pharmacies.id", ondelete="CASCADE"), nullable=False)
    product_id = Column(String(36), ForeignKey("products.id", ondelete="CASCADE"), nullable=False)
    quantity = Column(Integer, nullable=False, default=0)
    price_override = Column(DECIMAL(10, 2), nullable=True)
    expires_at = Column(Date, nullable=True)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    __table_args__ = (
        UniqueConstraint("pharmacy_id", "product_id", name="uq_inventory_pharmacy_product"),
    )

    pharmacy = relationship("Pharmacy", back_populates="inventory_items")
    product = relationship("Product")


# ---------------------------------------------------------------------------
# Address  (FK → users.id, NOT profiles.id)
# ---------------------------------------------------------------------------
class Address(Base):
    """User delivery address"""
    __tablename__ = "addresses"

    id = Column(String(36), primary_key=True, index=True, default=generate_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    label = Column(String(255), nullable=True)
    street = Column(Text, nullable=True)
    building = Column(Text, nullable=True)
    apartment = Column(Text, nullable=True)
    floor = Column(String(50), nullable=True)
    city = Column(String(100), nullable=True)
    governorate = Column(String(100), nullable=True)
    postal_code = Column(String(20), nullable=True)
    latitude = Column(DECIMAL(10, 7), nullable=True)
    longitude = Column(DECIMAL(10, 7), nullable=True)
    is_default = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="addresses")
    orders = relationship("Order", back_populates="address")


# ---------------------------------------------------------------------------
# Cart  (FK → users.id, NOT profiles.id)
# ---------------------------------------------------------------------------
class Cart(Base):
    """Shopping cart"""
    __tablename__ = "cart"

    id = Column(String(36), primary_key=True, index=True, default=generate_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, unique=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship("User", back_populates="cart")
    items = relationship("CartItem", back_populates="cart", cascade="all, delete-orphan")


# ---------------------------------------------------------------------------
# CartItem
# ---------------------------------------------------------------------------
class CartItem(Base):
    """Item inside a shopping cart"""
    __tablename__ = "cart_items"

    id = Column(String(36), primary_key=True, index=True, default=generate_uuid)
    cart_id = Column(String(36), ForeignKey("cart.id", ondelete="CASCADE"), nullable=False)
    product_id = Column(String(36), ForeignKey("products.id", ondelete="CASCADE"), nullable=False)
    quantity = Column(Integer, nullable=False, default=1)
    created_at = Column(DateTime, default=datetime.utcnow)

    __table_args__ = (
        UniqueConstraint("cart_id", "product_id", name="uq_cart_items_cart_product"),
    )

    cart = relationship("Cart", back_populates="items")
    product = relationship("Product")


# ---------------------------------------------------------------------------
# Order  (FK user_id → users.id, FK address_id → addresses.id)
# ---------------------------------------------------------------------------
class Order(Base):
    """Customer order"""
    __tablename__ = "orders"

    id = Column(String(36), primary_key=True, index=True, default=generate_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    address_id = Column(String(36), ForeignKey("addresses.id", ondelete="SET NULL"), nullable=True)
    pharmacy_id = Column(String(36), ForeignKey("pharmacies.id", ondelete="SET NULL"), nullable=True)
    status = Column(
        Enum("pending", "confirmed", "preparing", "shipped", "delivered", "cancelled",
             name="order_status_enum"),
        default="pending",
    )
    subtotal = Column(DECIMAL(10, 2), default=0)
    discount = Column(DECIMAL(10, 2), default=0)
    delivery_fee = Column(DECIMAL(10, 2), default=0)
    total = Column(DECIMAL(10, 2), default=0)
    payment_method = Column(
        Enum("cash", "card", "wallet", name="payment_method_enum"),
        nullable=True,
    )
    payment_status = Column(
        Enum("pending", "paid", "failed", "refunded", name="payment_status_enum"),
        default="pending",
    )
    notes = Column(Text, nullable=True)
    tracking_number = Column(String(100), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    delivered_at = Column(DateTime, nullable=True)

    user = relationship("User", back_populates="orders")
    pharmacy = relationship("Pharmacy", back_populates="orders")
    address = relationship("Address", back_populates="orders")
    items = relationship("OrderItem", back_populates="order", cascade="all, delete-orphan")


# ---------------------------------------------------------------------------
# OrderItem
# ---------------------------------------------------------------------------
class OrderItem(Base):
    """Item in an order"""
    __tablename__ = "order_items"

    id = Column(String(36), primary_key=True, index=True, default=generate_uuid)
    order_id = Column(String(36), ForeignKey("orders.id", ondelete="CASCADE"), nullable=False)
    product_id = Column(String(36), ForeignKey("products.id", ondelete="CASCADE"), nullable=False)
    quantity = Column(Integer, nullable=False)
    price = Column(DECIMAL(10, 2), nullable=False)
    total_price = Column(DECIMAL(10, 2), nullable=True)

    order = relationship("Order", back_populates="items")
    product = relationship("Product")


# ---------------------------------------------------------------------------
# Favorite  (FK → users.id, NOT profiles.id)
# ---------------------------------------------------------------------------
class Favorite(Base):
    """User favorite products"""
    __tablename__ = "favorites"

    id = Column(String(36), primary_key=True, index=True, default=generate_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    product_id = Column(String(36), ForeignKey("products.id", ondelete="CASCADE"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    __table_args__ = (
        UniqueConstraint("user_id", "product_id", name="uq_favorites_user_product"),
    )

    user = relationship("User", back_populates="favorites")
    product = relationship("Product")


# ---------------------------------------------------------------------------
# Review  (FK → users.id, NOT profiles.id)
# ---------------------------------------------------------------------------
class Review(Base):
    """Product reviews"""
    __tablename__ = "reviews"

    id = Column(String(36), primary_key=True, index=True, default=generate_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    product_id = Column(String(36), ForeignKey("products.id", ondelete="CASCADE"), nullable=False)
    rating = Column(Integer, nullable=False)
    comment = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    __table_args__ = (
        CheckConstraint("rating BETWEEN 1 AND 5", name="chk_reviews_rating"),
    )

    user = relationship("User", back_populates="reviews")
    product = relationship("Product")
