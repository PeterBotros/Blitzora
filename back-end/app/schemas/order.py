"""
Order schemas
"""
from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime
from decimal import Decimal
from enum import Enum
from app.schemas.product import ProductResponse


class OrderStatus(str, Enum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    SHIPPED = "shipped"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"


class PaymentMethod(str, Enum):
    CASH = "cash"
    CARD = "card"


class OrderCreate(BaseModel):
    """Schema to create a new order from current cart"""
    address_id: int
    pharmacy_id: int
    payment_method: PaymentMethod = PaymentMethod.CASH


class OrderStatusUpdate(BaseModel):
    """Schema to update an order's status"""
    status: OrderStatus


class OrderItemResponse(BaseModel):
    """Order item response schema"""
    id: int
    order_id: int
    product_id: int
    quantity: int
    price: Decimal
    product: Optional[ProductResponse] = None

    class Config:
        from_attributes = True


class OrderResponse(BaseModel):
    """Order response schema"""
    id: int
    user_id: Optional[int] = None
    address_id: Optional[int] = None
    pharmacy_id: Optional[int] = None
    status: OrderStatus
    subtotal: Optional[Decimal] = None
    discount: Optional[Decimal] = None
    total: Optional[Decimal] = None
    payment_method: Optional[PaymentMethod] = None
    created_at: datetime
    delivered_at: Optional[datetime] = None
    items: List[OrderItemResponse] = []

    class Config:
        from_attributes = True
