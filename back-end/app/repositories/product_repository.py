"""
Product repository - data access layer
"""
from sqlalchemy.orm import Session, noload
from typing import Optional, List
from app.models.catalog import Product, Category, ProductImage


class ProductRepository:
    """Product repository for database operations"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_by_id(self, product_id: int) -> Optional[Product]:
        """Get product by ID with category and images"""
        return self.db.query(Product).filter(Product.id == product_id).first()
    
    def get_all(
        self, 
        skip: int = 0, 
        limit: int = 100,
        category_id: Optional[int] = None,
        is_featured: Optional[bool] = None
    ) -> List[Product]:
        """Get all products with optional filters"""
        query = self.db.query(Product).options(
            noload(Product.category),
            noload(Product.images),
            noload(Product.offers)
        )
        
        if category_id is not None:
            query = query.filter(Product.category_id == category_id)
        
        if is_featured is not None:
            query = query.filter(Product.is_featured == is_featured)
        
        return query.offset(skip).limit(limit).all()
    
    def search_by_name(self, search_term: str, skip: int = 0, limit: int = 100) -> List[Product]:
        """Search products by name (case-insensitive for MySQL)"""
        return self.db.query(Product).options(
            noload(Product.category),
            noload(Product.images),
            noload(Product.offers)
        ).filter(
            Product.name.like(f"%{search_term}%")
        ).offset(skip).limit(limit).all()


class CategoryRepository:
    """Category repository for database operations"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_by_id(self, category_id: int) -> Optional[Category]:
        """Get category by ID"""
        return self.db.query(Category).filter(Category.id == category_id).first()
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[Category]:
        """Get all categories"""
        return self.db.query(Category).offset(skip).limit(limit).all()

