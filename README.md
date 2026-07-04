<div align="center">

<img src="https://img.shields.io/badge/Blitzora-v1.0.0-00C896?style=for-the-badge&logoColor=white" alt="Version"/>

# 💊 Blitzora

### Your Trusted Medicine Delivery & Pharmacy Platform

*A full-stack mobile application connecting patients with pharmacies for fast, reliable medicine delivery — with built-in AI assistance, real-time notifications, and seamless order management.*

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.116-009688?style=flat-square&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-336791?style=flat-square&logo=postgresql&logoColor=white)](https://postgresql.org)
[![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=flat-square&logo=python&logoColor=white)](https://python.org)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)

</div>

---

## 🎥 Demo

<div align="center">

https://github.com/user-attachments/assets/YOUR_VIDEO_ID_HERE.webm

</div>

---

## 📋 Table of Contents

- [Demo](#-demo)
- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Architecture](#-architecture)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Backend Setup](#backend-setup)
  - [Frontend Setup](#frontend-setup)
- [API Reference](#-api-reference)
- [Environment Variables](#-environment-variables)
- [Localization](#-localization)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 Overview

Blitzora is a **full-stack pharmacy delivery platform** built with Flutter (mobile) and FastAPI (backend). It enables users to browse medicines, place orders, locate nearby pharmacies on a live map, upload prescriptions, and chat with an AI pharmacy assistant — all from a single, beautifully designed app available in both **English and Arabic**.

---

## ✨ Features

### 📱 Mobile App (Flutter)
| Feature | Description |
|---|---|
| 🔐 **Authentication** | JWT-based login & registration with secure token persistence |
| 🏠 **Home Dashboard** | Personalized greeting, medication reminders, promo cards, swipeable categories |
| 💊 **Product Catalogue** | Browse medicines by category with search, filters, discount badges & ratings |
| 🗺️ **Pharmacy Map** | Live map with nearby pharmacy pins, hours, delivery availability & filter chips |
| 🛒 **Cart & Orders** | Add to cart, manage quantities, place and track orders |
| ❤️ **Favourites** | Save and manage favourite products |
| 🤖 **AI Chatbot** | Streaming AI responses via local Ollama (llama3.2) for medicine queries |
| 📋 **Prescription Upload** | Upload doctor prescriptions (images/PDF) verified by Google Gemini AI (checks doctor signature and issue date within 3 days) with automatic cart matching |
| 🔔 **Push Notifications** | Real-time OS-level push notifications for order updates |
| 👤 **Profile Management** | Edit name, phone, username; view orders and favourites |
| ⚙️ **Settings** | Dark/light theme toggle, language selection, notification preferences, biometric login |
| 🌐 **Bilingual (AR/EN)** | Full Arabic & English localization with RTL layout support |

### 🖥️ Backend (FastAPI)
| Feature | Description |
|---|---|
| 🔑 **JWT Auth** | HS256 token-based authentication with role support |
| 🗄️ **PostgreSQL + SQLAlchemy** | Relational data with ORM & Alembic migrations |
| 📦 **Product & Category API** | Full CRUD for products, categories, offers & inventory |
| 🏪 **Pharmacy API** | Pharmacy listings with location, hours & delivery status |
| 🛒 **Cart & Orders API** | Session cart management and full order lifecycle |
| ⭐ **Reviews & Favourites** | Product rating system and per-user favourites |
| 🔔 **Notifications API** | Push notification delivery and read-state management |
| 🤖 **Chatbot API** | Streaming LLM proxy via Ollama with SSE support |
| 📍 **Addresses API** | User saved addresses management |
| 📜 **Auto Docs** | Interactive Swagger UI at `/docs` and ReDoc at `/redoc` |

---

## 🛠 Tech Stack

### Frontend
| Layer | Technology |
|---|---|
| Framework | Flutter 3.x / Dart 3.x |
| State Management | flutter_bloc (BLoC pattern) |
| Dependency Injection | get_it |
| HTTP Client | Dio 5.x |
| Maps | flutter_map (OpenStreetMap) + geolocator |
| Localization | easy_localization |
| Notifications | flutter_local_notifications |
| Storage | shared_preferences |
| Architecture | Clean Architecture (Data / Domain / Presentation) |

### Backend
| Layer | Technology |
|---|---|
| Framework | FastAPI 0.116+ |
| Server | Uvicorn (ASGI) |
| Database | PostgreSQL 15+ |
| ORM | SQLAlchemy 2.x |
| Migrations | Alembic |
| Auth | python-jose (JWT) + passlib (bcrypt) |
| Validation | Pydantic v2 + pydantic-settings |
| AI / LLM | Ollama (llama3.2) & Google Gemini (gemini-1.5-flash) |
| Config | python-dotenv |

---

## 📁 Project Structure

```
blitzora/
├── back-end/                         # FastAPI Python backend
│   ├── app/
│   │   ├── api/
│   │   │   └── v1/
│   │   │       ├── endpoints/        # Route handlers
│   │   │       │   ├── auth.py       # Login, register, refresh
│   │   │       │   ├── users.py      # User profile CRUD
│   │   │       │   ├── products.py   # Product catalogue
│   │   │       │   ├── categories.py # Product categories
│   │   │       │   ├── pharmacies.py # Pharmacy listings & map data
│   │   │       │   ├── cart.py       # Shopping cart
│   │   │       │   ├── orders.py     # Order management
│   │   │       │   ├── favorites.py  # User favourites
│   │   │       │   ├── reviews.py    # Product reviews
│   │   │       │   ├── offers.py     # Promotional offers
│   │   │       │   ├── addresses.py  # Saved addresses
│   │   │       │   ├── notifications.py # Push notifications
│   │   │       │   └── chatbot.py    # AI chatbot (SSE streaming)
│   │   │       └── router.py         # Aggregated API router
│   │   ├── core/
│   │   │   ├── config.py             # App settings (pydantic-settings)
│   │   │   └── database.py           # SQLAlchemy engine & session
│   │   ├── models/                   # SQLAlchemy ORM models
│   │   │   ├── user.py
│   │   │   ├── product.py
│   │   │   ├── catalog.py
│   │   │   ├── pharmacy.py
│   │   │   ├── cart.py
│   │   │   ├── order.py
│   │   │   ├── favorite.py
│   │   │   ├── review.py
│   │   │   ├── notification.py
│   │   │   └── address.py
│   │   ├── repositories/             # Data access layer
│   │   ├── schemas/                  # Pydantic request/response schemas
│   │   ├── services/                 # Business logic services
│   │   └── main.py                   # FastAPI app entry point
│   └── requirements.txt
│
└── front-end/                        # Flutter mobile app
    ├── lib/
    │   ├── core/
    │   │   ├── constants/            # App-wide constants & colors
    │   │   ├── errors/               # Exception & failure types
    │   │   ├── network/              # Dio client setup & interceptors
    │   │   ├── routes/               # Named route definitions
    │   │   ├── services/             # Notification service
    │   │   ├── theme/                # Light & dark theme tokens
    │   │   └── wrapper/              # MainWrapper (bottom nav shell)
    │   ├── features/
    │   │   ├── auth/                 # Login / Register screens
    │   │   ├── home/                 # Dashboard, categories, pharmacies
    │   │   ├── products/             # Product grid, detail, search
    │   │   ├── cart/                 # Cart management
    │   │   ├── orders/               # Order history & tracking
    │   │   ├── map/                  # Pharmacy map (flutter_map)
    │   │   ├── chatbot/              # AI chat interface
    │   │   ├── prescription/         # Prescription upload
    │   │   └── profile/              # Profile & settings pages
    │   ├── injection/
    │   │   └── injection_container.dart  # GetIt DI registration
    │   └── main.dart                 # App entry point
    ├── assets/
    │   └── translations/
    │       ├── en.json               # English strings
    │       └── ar.json               # Arabic strings
    └── pubspec.yaml
```

---

## 🏛 Architecture

### Frontend — Clean Architecture

The Flutter app strictly follows **Clean Architecture** with three isolated layers per feature:

```
Presentation Layer  ──→  BLoC (Events / States)
                              ↓
Domain Layer        ──→  Use Cases  →  Repository Interface  →  Entities
                              ↓
Data Layer          ──→  Repository Impl  →  Remote DataSource (Dio)  →  Models
```

- **Domain** layer is pure Dart — no Flutter or external framework dependencies.
- **BLoC** pattern drives all state changes; UI only emits events and renders states.
- **GetIt** handles dependency injection across all layers.

### Backend — Layered FastAPI

```
HTTP Request  →  FastAPI Router  →  Endpoint  →  Service  →  Repository  →  SQLAlchemy Model  →  PostgreSQL
                                        ↑
                                   Pydantic Schema (validation & serialization)
```

- **Endpoints** handle HTTP routing and auth guards only.
- **Services** contain all business logic.
- **Repositories** are the single point of contact with the database.
- **Schemas** separate internal models from API contracts.

---

## 🚀 Getting Started

### Prerequisites

| Tool | Version | Purpose |
|---|---|---|
| Flutter | 3.x | Mobile app |
| Dart | 3.x | Flutter SDK |
| Python | 3.10+ | Backend |
| PostgreSQL | 15+ | Database |
| Ollama | latest | Local AI inference |
| Git | any | Version control |

---

### Backend Setup

**1. Clone the repository**
```bash
git clone https://github.com/your-org/blitzora.git
cd blitzora/back-end
```

**2. Create and activate a virtual environment**
```bash
python -m venv venv

# Windows
venv\Scripts\activate

# macOS / Linux
source venv/bin/activate
```

**3. Install dependencies**
```bash
pip install -r requirements.txt
```

**4. Create the PostgreSQL database**
```sql
CREATE USER blitzora_user WITH PASSWORD 'blitzora_pass';
CREATE DATABASE blitzora_db OWNER blitzora_user;
```

**5. Configure environment variables**

Create a `.env` file in `back-end/`:
```env
DATABASE_URL=postgresql+psycopg2://blitzora_user:blitzora_pass@localhost:5432/blitzora_db
SECRET_KEY=your-super-secret-key-change-this-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
ENVIRONMENT=development
DEBUG=True

# Ollama (AI Chatbot)
OLLAMA_URL=http://localhost:11434
OLLAMA_MODEL=llama3.2

# Gemini (AI Prescription Verification)
GEMINI_API_KEY=your_gemini_api_key_here
```

**6. Start Ollama and pull the model** *(required for chatbot)*
```bash
ollama serve
ollama pull llama3.2
```

**7. Run the server**
```bash
# From the back-end/ directory
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

> ✅ Tables are auto-created on first startup — no migration step required for development.

The API will be available at:
- **Base URL**: `http://localhost:8000`
- **Swagger UI**: `http://localhost:8000/docs`
- **ReDoc**: `http://localhost:8000/redoc`
- **Health Check**: `http://localhost:8000/health`

---

### Frontend Setup

**1. Navigate to the frontend directory**
```bash
cd blitzora/front-end
```

**2. Install Flutter dependencies**
```bash
flutter pub get
```

**3. Configure the API base URL**

Open `lib/core/network/` and set your backend URL. For local development with a physical device, use your machine's local IP instead of `localhost`.

**4. Run the app**
```bash
# Debug mode (recommended for development)
flutter run

# Specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

**5. Build for release** *(optional)*
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 📡 API Reference

All endpoints are prefixed with `/api/v1`.

| Module | Prefix | Key Endpoints |
|---|---|---|
| **Authentication** | `/auth` | `POST /register`, `POST /login`, `POST /refresh` |
| **Users** | `/users` | `GET /me`, `PUT /me`, `GET /{id}` |
| **Products** | `/products` | `GET /`, `GET /{id}`, `GET /?category=&search=` |
| **Categories** | `/categories` | `GET /`, `GET /{id}/products` |
| **Pharmacies** | `/pharmacies` | `GET /`, `GET /{id}`, `GET /nearby` |
| **Cart** | `/cart` | `GET /`, `POST /items`, `PUT /items/{id}`, `DELETE /items/{id}` |
| **Orders** | `/orders` | `GET /`, `POST /`, `GET /{id}`, `PUT /{id}/status` |
| **Favourites** | `/favorites` | `GET /`, `POST /{product_id}`, `DELETE /{product_id}` |
| **Reviews** | `/reviews` | `GET /?product_id=`, `POST /`, `DELETE /{id}` |
| **Offers** | `/offers` | `GET /` |
| **Addresses** | `/addresses` | `GET /`, `POST /`, `PUT /{id}`, `DELETE /{id}` |
| **Notifications** | `/notifications` | `GET /`, `PUT /{id}/read`, `PUT /read-all` |
| **Chatbot** | `/chatbot` | `POST /chat` *(Server-Sent Events streaming)* |

> 📖 Full interactive documentation is auto-generated at `/docs` when the server is running.

---

## 🔐 Environment Variables

### Backend (`.env` in `back-end/`)

| Variable | Default | Description |
|---|---|---|
| `DATABASE_URL` | `postgresql+psycopg2://...` | Full PostgreSQL connection string |
| `SECRET_KEY` | *(required)* | JWT signing secret — **change in production** |
| `ALGORITHM` | `HS256` | JWT algorithm |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | `30` | Token expiry in minutes |
| `ENVIRONMENT` | `development` | App environment |
| `DEBUG` | `True` | Enable debug mode |
| `OLLAMA_URL` | `http://localhost:11434` | Ollama server URL |
| `OLLAMA_MODEL` | `llama3.2` | LLM model name to use |
| `GEMINI_API_KEY` | *(optional)* | Google Gemini API key to enable prescription verification. Bypassed if not configured. |

> ⚠️ **Never commit your `.env` file.** It is already listed in `.gitignore`.

---

## 🌐 Localization

The app is fully localized in **English** and **Arabic** using `easy_localization`.

Translation files are located at:
```
front-end/assets/translations/
├── en.json   # English
└── ar.json   # Arabic (with RTL support)
```

To add a new string:
1. Add the key-value pair to both `en.json` and `ar.json`
2. Use `'your_key'.tr()` in any widget

Language can be changed at runtime from **Settings → App Language** — the entire app switches locale including RTL layout direction immediately without restart.

---

## 🗂 Database Schema (Overview)

```
users ──────────────────────────────────────────┐
  │                                              │
  ├──< orders >──< order_items >──< products >──┤
  │                                    │         │
  ├──< cart_items >───────────────────┘         │
  │                                              │
  ├──< favorites >────────────────── products   │
  │                                              │
  ├──< reviews >──────────────────── products   │
  │                                              │
  ├──< addresses >                               │
  │                                              │
  ├──< notifications >                           │
  │                                              │
  └──> profile                                   │
                                                 │
pharmacies ──< inventory >─────────── products ─┘
              (stock levels per pharmacy)

categories ──< products
```

---

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/your-feature`
3. **Follow** the existing architecture — keep each layer's responsibilities separate
4. **Add** translations to both `en.json` and `ar.json` for any new UI text
5. **Test** your changes on both light and dark themes, and in both locales
6. **Commit** with a clear message: `git commit -m "feat: add X feature"`
7. **Push** and open a **Pull Request**

### Code Style
- **Flutter/Dart**: Follow the rules in `analysis_options.yaml`; run `flutter analyze` before pushing
- **Python**: Follow PEP 8; use type hints throughout

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](front-end/LICENSE) file for details.

---

<div align="center">

Built with ❤️ using Flutter & FastAPI

</div>
