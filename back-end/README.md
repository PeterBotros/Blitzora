# Blitzora Backend API

FastAPI-based backend for the Blitzora application.

## Project Structure

```
back-end/
├── app/
│   ├── api/              # API routes and endpoints
│   │   └── v1/
│   │       ├── endpoints/ # Endpoint handlers
│   │       └── router.py  # API router
│   ├── core/             # Core functionality
│   │   ├── config.py     # Configuration settings
│   │   ├── database.py   # Database setup
│   │   ├── exceptions.py # Custom exceptions
│   │   └── security.py   # Security utilities
│   ├── models/           # SQLAlchemy models
│   ├── repositories/     # Data access layer
│   ├── schemas/          # Pydantic schemas
│   ├── services/         # Business logic layer
│   └── main.py           # Application entry point
├── alembic/              # Database migrations (to be generated)
├── venv/                 # Virtual environment
├── .env                  # Environment variables (not in git)
├── .env.example          # Example environment variables
├── requirements.txt      # Python dependencies
└── README.md             # This file
```

## Architecture

This backend follows **Clean Architecture** principles:

- **API Layer** (`app/api/`): Handles HTTP requests and responses
- **Service Layer** (`app/services/`): Contains business logic
- **Repository Layer** (`app/repositories/`): Data access abstraction
- **Model Layer** (`app/models/`): Database models (SQLAlchemy)
- **Schema Layer** (`app/schemas/`): Request/response validation (Pydantic)

## Setup

1. **Activate virtual environment:**
   ```powershell
   cd back-end
   .\venv\Scripts\activate.bat
   ```

2. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Create `.env` file:**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` with your database credentials and settings.

4. **Run database migrations:**
   ```bash
   alembic init alembic
   alembic revision --autogenerate -m "Initial migration"
   alembic upgrade head
   ```

5. **Run the development server:**
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

## API Documentation

Once the server is running, access:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Environment Variables

See `.env.example` for all available environment variables.

## Development

- The API follows RESTful conventions
- All endpoints are versioned under `/api/v1/`
- Authentication uses JWT tokens
- Database uses SQLAlchemy ORM with MySQL

