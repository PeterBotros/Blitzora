"""
Product repository - data access layer
"""
from sqlalchemy.orm import Session, noload
from typing import Optional, List
from app.models.catalog import Product, Category, ProductImage
from app.schemas.product import ProductCreate


class ProductRepository:
    """Product repository for database operations"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_by_id(self, product_id: str) -> Optional[Product]:
        """Get product by ID with category and images"""
        return self.db.query(Product).filter(Product.id == product_id).first()
    
    def get_all(
        self, 
        skip: int = 0, 
        limit: int = 100,
        category_id: Optional[int] = None,
        is_featured: Optional[bool] = None,
        search: Optional[str] = None,
        sort_by: Optional[str] = None
    ) -> List[Product]:
        """Get all products with optional filters, search, and sorting"""
        query = self.db.query(Product).options(
            noload(Product.category),
            noload(Product.images),
            noload(Product.offers)
        )
        
        if category_id is not None:
            query = query.filter(Product.category_id == category_id)
        
        if is_featured is not None:
            query = query.filter(Product.is_featured == is_featured)

        if search:
            query = query.filter(Product.name.like(f"%{search}%"))

        # Sorting logic
        if sort_by == "price_asc":
            query = query.order_by(Product.price.asc())
        elif sort_by == "price_desc":
            query = query.order_by(Product.price.desc())
        elif sort_by == "name_asc":
            query = query.order_by(Product.name.asc())
        elif sort_by == "name_desc":
            query = query.order_by(Product.name.desc())
        elif sort_by == "newest":
            query = query.order_by(Product.created_at.desc())
        else:
            query = query.order_by(Product.id.asc())
        
        return query.offset(skip).limit(limit).all()
    
    def search_by_name(self, search_term: str, skip: int = 0, limit: int = 100) -> List[Product]:
        """Search products by name"""
        return self.db.query(Product).options(
            noload(Product.category),
            noload(Product.images),
            noload(Product.offers)
        ).filter(
            Product.name.like(f"%{search_term}%")
        ).offset(skip).limit(limit).all()

    def create(self, product_data: ProductCreate) -> Product:
        """Create a new product with optional images"""
        db_product = Product(
            name=product_data.name,
            description=product_data.description,
            category_id=product_data.category_id,
            price=product_data.price,
            discount_percent=product_data.discount_percent,
            stock=product_data.stock,
            image_url=product_data.image_url,
            is_featured=product_data.is_featured
        )
        self.db.add(db_product)
        self.db.flush()

        if product_data.images:
            for img in product_data.images:
                db_img = ProductImage(product_id=db_product.id, image_url=img.image_url)
                self.db.add(db_img)

        self.db.commit()
        self.db.refresh(db_product)
        return db_product

    def update(self, product: Product, update_data: dict) -> Product:
        """Update a product and its images"""
        images_data = update_data.pop("images", None)
        for field, value in update_data.items():
            setattr(product, field, value)

        if images_data is not None:
            # Drop old images and replace with new ones
            self.db.query(ProductImage).filter(ProductImage.product_id == product.id).delete()
            for img in images_data:
                db_img = ProductImage(product_id=product.id, image_url=img.get("image_url"))
                self.db.add(db_img)

        self.db.commit()
        self.db.refresh(product)
        return product

    def delete(self, product: Product) -> bool:
        """Delete a product"""
        self.db.delete(product)
        self.db.commit()
        return True


class CategoryRepository:
    """Category repository for database operations"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_by_id(self, category_id: str) -> Optional[Category]:
        """Get category by ID"""
        return self.db.query(Category).filter(Category.id == category_id).first()
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[Category]:
        """Get all categories"""
        return self.db.query(Category).offset(skip).limit(limit).all()
