# Blitzora API

Backend API for **Blitzora**, a pharmacy delivery platform. Built with **FastAPI** and **SQLAlchemy**, backed by **PostgreSQL**.

Handles authentication, pharmacy & product catalog management, cart, orders, addresses, favorites, and reviews — with role-based access for `user`, `admin`, and `pharmacy_staff` accounts.

## Tech Stack

- **Framework:** FastAPI
- **ORM:** SQLAlchemy
- **Database:** PostgreSQL
- **Auth:** JWT (OAuth2 password flow), `python-jose` + `passlib`/`bcrypt`
- **Validation:** Pydantic v2 / `pydantic-settings`

## Project Structure

```
app/
├── main.py                  # App entry point, CORS, startup table creation
├── core/
│   ├── config.py            # Environment-driven settings
│   ├── database.py          # SQLAlchemy engine/session setup
│   ├── dependencies.py       # Auth dependencies (current user, role checks)
│   ├── security.py           # Password hashing, JWT encode/decode
│   ├── exceptions.py          # Shared HTTPException helpers
│   └── utils.py               # generate_uuid() — shared ID generator
├── models/                  # SQLAlchemy models (catalog.py, pharmacy.py, user.py)
├── schemas/                 # Pydantic request/response schemas
├── repositories/            # Direct DB access layer (one per domain)
├── services/                # Business logic layer (one per domain)
└── api/v1/
    ├── router.py             # Aggregates all endpoint routers
    └── endpoints/             # One file per resource (auth, products, orders, ...)
```

All primary keys are **string UUIDs**, auto-generated at insert time via `generate_uuid()` — there are no integer/autoincrement IDs anywhere in the schema.

## Getting Started

### Prerequisites
- Python 3.12+
- PostgreSQL 14+ running locally or remotely

### Installation

```bash
git clone <repo-url>
cd <repo-folder>
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install fastapi uvicorn sqlalchemy psycopg2-binary pydantic pydantic-settings python-jose[cryptography] passlib[bcrypt] python-multipart
```

> A pinned `requirements.txt` isn't included yet — see [Known Gaps](#known-gaps--next-steps) below.

### Configuration

Create a `.env` file in the project root:

```env
DATABASE_URL=postgresql://postgres:1234@localhost:5432/blitzora
SECRET_KEY=change-this-to-a-long-random-string
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
ENVIRONMENT=development
DEBUG=True
```

| Variable | Default | Description |
|---|---|---|
| `DATABASE_URL` | `postgresql://postgres:1234@localhost:5432/blitzora` | Postgres connection string |
| `SECRET_KEY` | *(placeholder — must override)* | JWT signing secret |
| `ALGORITHM` | `HS256` | JWT signing algorithm |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | `30` | Access token lifetime |
| `CORS_ORIGINS` | `localhost:3000`, `localhost:8080` | Allowed frontend origins |
| `ENVIRONMENT` | `development` | Environment label |
| `DEBUG` | `True` | Debug flag |

### Running

```bash
uvicorn app.main:app --reload
```

On startup, the app calls `Base.metadata.create_all()` and will create any missing tables in the target database automatically (it will **not** alter existing tables — see [Known Gaps](#known-gaps--next-steps)).

- API base URL: `http://localhost:8000`
- Interactive docs (Swagger UI): `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`
- Health check: `GET /health`

### Authenticating in Swagger UI

Click **Authorize**, enter a user's email (or username) in the `username` field and their password in `password`, leave `client_id`/`client_secret` blank. This hits a dedicated form-encoded `/api/v1/auth/token` endpoint built specifically for the OAuth2 Authorize flow — your actual client apps should keep using the JSON `/api/v1/auth/login` endpoint.

## API Overview

All routes are prefixed with `/api/v1`.

| Resource | Prefix | Notes |
|---|---|---|
| Auth | `/auth` | `login` (JSON), `token` (form, Swagger-only), `register`, `refresh`, `forgot-password`, `reset-password`, `me` |
| Users | `/users` | List, get, delete |
| Products | `/products` | CRUD |
| Categories | `/categories` | CRUD |
| Offers | `/offers` | List, active, global |
| Pharmacies | `/pharmacies` | CRUD + `nearby` search |
| Cart | `/cart` | View, add, update, remove items |
| Addresses | `/addresses` | CRUD |
| Orders | `/orders` | Place order, list, get, update status |
| Favorites | `/favorites` | List, add, remove |
| Reviews | `/reviews` | Create, list by product, delete |

Full request/response schemas are available interactively at `/docs`.

### Roles

| Role | Description |
|---|---|
| `user` | Default role — browses, orders, manages own cart/addresses/favorites/reviews |
| `pharmacy_staff` | Manages their pharmacy's listing |
| `admin` | Full management access (categories, products, pharmacies, users) |

> There is currently no API endpoint to promote a user to `admin` — see [Known Gaps](#known-gaps--next-steps).

## Database

- Models are organized into `models/user.py`, `models/catalog.py` (Category, Product, ProductImage, Offer), and `models/pharmacy.py` (Pharmacy, PharmacyInventory, Profile, Address, Cart, CartItem, Order, OrderItem, Favorite, Review).
- A handful of placeholder files (`address.py`, `cart.py`, `category.py`, `favorite.py`, `inventory.py`, `notification.py`, `order.py`, `product.py`, `profile.py`, `review.py`) exist under `models/` but are empty and unused — the real classes live in the three files above.
- Seed CSVs for `categories`, `products`, and `offers` can be generated and bulk-loaded with `psql`'s `\copy` — **load in this order: categories → products → offers**, since later tables have foreign keys into earlier ones.

## Known Gaps / Next Steps

This project is functional end-to-end but has a few open items:

- **No `requirements.txt` / dependency pinning yet.**
- **No Alembic migrations** — schema changes currently require manually altering the live database or rebuilding tables; `create_all()` only creates missing tables, it never alters existing ones.
- **No automated tests.**
- **Pharmacy inventory (`PharmacyInventory`) isn't wired into order placement** — stock is currently deducted from `Product.stock` directly rather than per-pharmacy stock.
- **`Notification` model is unimplemented** (empty placeholder file, no schema/service/endpoints).
- **No endpoint to promote a user to `admin`** — must be done directly in the database for the first admin account.
- **Password reset returns the token in the API response** instead of emailing it — fine for development, not for production.
- **No rate limiting** on auth endpoints.

## License

Internal project — license terms TBD.
