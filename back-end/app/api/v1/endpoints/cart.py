"""
Cart endpoints
"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User
from app.schemas.cart import CartResponse, CartItemResponse, CartItemCreate, CartItemUpdate
from app.services.cart_service import CartService
from app.core.exceptions import (
    NotFoundError,
    ValidationError,
    not_found_exception,
    validation_exception,
)

router = APIRouter()


@router.get("/", response_model=CartResponse)
async def get_cart(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Retrieve current user's shopping cart"""
    service = CartService(db)
    return service.get_user_cart(current_user.id)


@router.post("/add", response_model=CartItemResponse, status_code=status.HTTP_201_CREATED)
async def add_item_to_cart(
    item_data: CartItemCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Add a product to the shopping cart"""
    service = CartService(db)
    try:
        return service.add_item_to_cart(current_user.id, item_data)
    except NotFoundError as e:
        raise not_found_exception(str(e))
    except ValidationError as e:
        raise validation_exception(str(e))


@router.put("/item/{id}", response_model=CartItemResponse)
async def update_cart_item(
    id: str,
    update_data: CartItemUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Update item quantity in the shopping cart"""
    service = CartService(db)
    try:
        return service.update_cart_item(current_user.id, id, update_data)
    except NotFoundError as e:
        raise not_found_exception(str(e))
    except ValidationError as e:
        raise validation_exception(str(e))


@router.delete("/item/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def remove_cart_item(
    id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Remove a product from the shopping cart"""
    service = CartService(db)
    try:
        service.remove_cart_item(current_user.id, id)
        return None
    except NotFoundError as e:
        raise not_found_exception(str(e))
