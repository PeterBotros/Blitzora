"""
Order endpoints
"""
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User, UserRole
from app.schemas.order import OrderResponse, OrderCreate, OrderStatusUpdate
from app.services.order_service import OrderService
from app.core.exceptions import (
    NotFoundError,
    ValidationError,
    not_found_exception,
    validation_exception,
    authorization_exception,
)

router = APIRouter()


@router.post("/", response_model=OrderResponse, status_code=status.HTTP_201_CREATED)
async def place_order(
    order_data: OrderCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Place a new order from current shopping cart"""
    service = OrderService(db)
    try:
        return service.place_order(current_user.id, order_data)
    except ValidationError as e:
        raise validation_exception(str(e))


@router.get("/", response_model=List[OrderResponse])
async def get_orders(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    Retrieve order history.
    Users get their own orders; admins/pharmacy staff get all orders globally.
    """
    service = OrderService(db)
    if current_user.role in [UserRole.ADMIN.value, UserRole.PHARMACY_STAFF.value]:
        return service.get_all_orders_admin(skip, limit)
    return service.get_my_orders(current_user.id, skip, limit)


@router.get("/{id}", response_model=OrderResponse)
async def get_order(
    id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Retrieve details of a specific order"""
    service = OrderService(db)
    try:
        return service.get_order_details(id, current_user.id, current_user.role)
    except NotFoundError as e:
        raise not_found_exception(str(e))


@router.put("/{id}/status", response_model=OrderResponse)
async def update_order_status(
    id: str,
    status_data: OrderStatusUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Update status of an order (Admin/Pharmacy staff only)"""
    if current_user.role not in [UserRole.ADMIN.value, UserRole.PHARMACY_STAFF.value]:
        raise authorization_exception("Only admins or pharmacy staff can update order status")

    service = OrderService(db)
    try:
        return service.update_status(id, status_data)
    except NotFoundError as e:
        raise not_found_exception(str(e))
