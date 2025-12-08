"""
Product service - business logic layer
"""
from sqlalchemy.orm import Session
from typing import Optional, List
from app.repositories.product_repository import ProductRepository, CategoryRepository
from app.schemas.product import ProductResponse, ProductListResponse
from app.schemas.category import CategoryResponse
from app.core.exceptions import NotFoundError


class ProductService:
    """Product service for business logic"""
    
    def __init__(self, db: Session):
        self.repository = ProductRepository(db)
    
    def get_product_by_id(self, product_id: int) -> ProductResponse:
        """Get product by ID"""
        product = self.repository.get_by_id(product_id)
        if not product:
            raise NotFoundError(f"Product with ID {product_id} not found")
        return ProductResponse.model_validate(product)
    
    def get_all_products(
        self,
        skip: int = 0,
        limit: int = 100,
        category_id: Optional[int] = None,
        is_featured: Optional[bool] = None
    ) -> List[ProductListResponse]:
        """Get all products with optional filters"""
        products = self.repository.get_all(skip, limit, category_id, is_featured)
        return [ProductListResponse.model_validate(p) for p in products]
    
    def search_products(self, search_term: str, skip: int = 0, limit: int = 100) -> List[ProductListResponse]:
        """Search products by name"""
        products = self.repository.search_by_name(search_term, skip, limit)
        return [ProductListResponse.model_validate(p) for p in products]


class CategoryService:
    """Category service for business logic"""
    
    def __init__(self, db: Session):
        self.repository = CategoryRepository(db)
    
    def get_category_by_id(self, category_id: int) -> CategoryResponse:
        """Get category by ID"""
        category = self.repository.get_by_id(category_id)
        if not category:
            raise NotFoundError(f"Category with ID {category_id} not found")
        return CategoryResponse.model_validate(category)
    
    def get_all_categories(self, skip: int = 0, limit: int = 100) -> List[CategoryResponse]:
        """Get all categories"""
        categories = self.repository.get_all(skip, limit)
        return [CategoryResponse.model_validate(c) for c in categories]

