"""
API v1 router - aggregates all endpoint routers
"""
from fastapi import APIRouter
from app.api.v1.endpoints import (
    auth,
    users,
    products,
    pharmacies,
    offers,
    categories,
    cart,
    addresses,
    orders,
    favorites,
    reviews,
    chatbot,
    notifications,
)

api_router = APIRouter()

# Include endpoint routers
api_router.include_router(auth.router, prefix="/auth", tags=["authentication"])
api_router.include_router(users.router, prefix="/users", tags=["users"])
api_router.include_router(products.router, prefix="/products", tags=["products"])
api_router.include_router(pharmacies.router, prefix="/pharmacies")
api_router.include_router(offers.router, prefix="/offers", tags=["offers"])
api_router.include_router(categories.router, prefix="/categories", tags=["categories"])
api_router.include_router(cart.router, prefix="/cart", tags=["cart"])
api_router.include_router(addresses.router, prefix="/addresses", tags=["addresses"])
api_router.include_router(orders.router, prefix="/orders", tags=["orders"])
api_router.include_router(favorites.router, prefix="/favorites", tags=["favorites"])
api_router.include_router(reviews.router, prefix="/reviews", tags=["reviews"])
api_router.include_router(chatbot.router, prefix="/chatbot")
api_router.include_router(notifications.router, prefix="/notifications", tags=["notifications"])