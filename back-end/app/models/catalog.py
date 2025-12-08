"""
Catalog-related models: categories, products, product images, offers.
"""
from datetime import datetime, date

from sqlalchemy import (
    Boolean,
    Column,
    Date,
    DateTime,
    DECIMAL,
    ForeignKey,
    Integer,
    String,
    Text,
)
from sqlalchemy.orm import relationship

from app.core.database import Base


class Category(Base):
    """Product category model"""

    __tablename__ = "categories"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    name = Column(String(255), nullable=False, unique=True, index=True)
    image_url = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    products = relationship("Product", back_populates="category")


class Product(Base):
    """Product model"""

    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    name = Column(String(255), nullable=False, index=True)
    description = Column(Text, nullable=True)
    category_id = Column(Integer, ForeignKey("categories.id", ondelete="SET NULL"))
    price = Column(DECIMAL(10, 2), nullable=False)
    discount_percent = Column(Integer, default=0)
    stock = Column(Integer, default=0)
    image_url = Column(Text, nullable=True)
    is_featured = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    category = relationship("Category", back_populates="products")
    images = relationship(
        "ProductImage", back_populates="product", cascade="all, delete-orphan"
    )
    offers = relationship("Offer", back_populates="product")


class ProductImage(Base):
    """Additional product images"""

    __tablename__ = "product_images"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    product_id = Column(
        Integer, ForeignKey("products.id", ondelete="CASCADE"), nullable=False
    )
    image_url = Column(Text, nullable=False)

    product = relationship("Product", back_populates="images")


class Offer(Base):
    """Offers and promotions"""

    __tablename__ = "offers"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    title = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    discount_percent = Column(Integer, nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    product_id = Column(Integer, ForeignKey("products.id", ondelete="CASCADE"))
    is_global = Column(Boolean, default=False)

    product = relationship("Product", back_populates="offers")


