"""
Main application entry point
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import os
from app.core.config import settings
from app.core.database import engine, Base
from app.api.v1.router import api_router

# Import all models so SQLAlchemy registers them with Base before create_all()
import app.models  # noqa: F401

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description=settings.DESCRIPTION,
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API router
app.include_router(api_router, prefix=settings.API_V1_PREFIX)

# Ensure uploads directories exist and mount static route
os.makedirs(os.path.join("uploads", "prescriptions"), exist_ok=True)
app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")


@app.on_event("startup")
def on_startup():
    """
    Create all database tables on startup if they don't already exist.
    This ensures the app works out-of-the-box without running db.sql manually.
    Also executes schema migrations for prescriptions table.
    """
    Base.metadata.create_all(bind=engine)
    
    # Run simple migrations to add AI verification fields if they don't exist
    from sqlalchemy import text
    with engine.begin() as conn:
        conn.execute(text("ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS diagnosis_date DATE;"))
        conn.execute(text("ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS prescription_date DATE;"))
        conn.execute(text("ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS is_valid BOOLEAN DEFAULT TRUE;"))
        conn.execute(text("ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS rejection_reason TEXT;"))
        conn.execute(text("ALTER TABLE prescriptions ADD COLUMN IF NOT EXISTS extracted_medicines TEXT;"))


@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "Blitzora API",
        "version": settings.VERSION,
        "status": "running"
    }


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy"}

