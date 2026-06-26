"""
Product service - business logic layer
"""
from sqlalchemy.orm import Session
from typing import Optional, List
from app.repositories.product_repository import ProductRepository, CategoryRepository
from app.schemas.product import ProductResponse, ProductListResponse, ProductCreate, ProductUpdate
from app.schemas.category import CategoryResponse
from app.core.exceptions import NotFoundError


class ProductService:
    """Product service for business logic"""
    
    def __init__(self, db: Session):
        self.repository = ProductRepository(db)
    
    def get_product_by_id(self, product_id: str) -> ProductResponse:
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
        is_featured: Optional[bool] = None,
        search: Optional[str] = None,
        sort_by: Optional[str] = None
    ) -> List[ProductListResponse]:
        """Get all products with optional filters, search, and sorting"""
        products = self.repository.get_all(skip, limit, category_id, is_featured, search, sort_by)
        return [ProductListResponse.model_validate(p) for p in products]
    
    def search_products(self, search_term: str, skip: int = 0, limit: int = 100) -> List[ProductListResponse]:
        """Search products by name"""
        products = self.repository.search_by_name(search_term, skip, limit)
        return [ProductListResponse.model_validate(p) for p in products]

    def create_product(self, product_data: ProductCreate) -> ProductResponse:
        """Create a new product"""
        product = self.repository.create(product_data)
        return ProductResponse.model_validate(product)

    def update_product(self, product_id: str, update_data: ProductUpdate) -> ProductResponse:
        """Update a product"""
        product = self.repository.get_by_id(product_id)
        if not product:
            raise NotFoundError(f"Product with ID {product_id} not found")
        
        update_dict = update_data.model_dump(exclude_unset=True)
        updated_product = self.repository.update(product, update_dict)
        return ProductResponse.model_validate(updated_product)

    def delete_product(self, product_id: str) -> bool:
        """Delete a product"""
        product = self.repository.get_by_id(product_id)
        if not product:
            raise NotFoundError(f"Product with ID {product_id} not found")
        return self.repository.delete(product)


class CategoryService:
    """Category service for business logic"""
    
    def __init__(self, db: Session):
        self.repository = CategoryRepository(db)
    
    def get_category_by_id(self, category_id: str) -> CategoryResponse:
        """Get category by ID"""
        category = self.repository.get_by_id(category_id)
        if not category:
            raise NotFoundError(f"Category with ID {category_id} not found")
        return CategoryResponse.model_validate(category)
    
    def get_all_categories(self, skip: int = 0, limit: int = 100) -> List[CategoryResponse]:
        """Get all categories"""
        categories = self.repository.get_all(skip, limit)
        return [CategoryResponse.model_validate(c) for c in categories]
