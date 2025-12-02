# Clean Architecture Structure

This Flutter project follows **Clean Architecture** principles, ensuring separation of concerns, testability, and maintainability.

## Project Structure

```
lib/
├── core/                          # Shared code across features
│   ├── constants/                 # App-wide constants
│   │   └── app_constants.dart
│   ├── errors/                    # Error handling
│   │   ├── exceptions.dart        # Custom exceptions
│   │   └── failures.dart          # Failure classes
│   ├── routes/                    # App routing
│   │   └── app_routes.dart
│   ├── theme/                     # App theming
│   │   └── app_theme.dart
│   ├── usecases/                  # Base use case classes
│   │   └── usecase.dart
│   └── utils/                     # Utility functions
│       ├── input_validator.dart
│       └── typedef.dart
│
├── features/                      # Feature modules
│   └── [feature_name]/
│       ├── data/                  # Data layer
│       │   ├── datasources/       # Data sources (API, Local DB)
│       │   │   ├── [feature]_remote_datasource.dart
│       │   │   └── [feature]_local_datasource.dart
│       │   ├── models/            # Data models (extend entities)
│       │   │   └── [feature]_model.dart
│       │   └── repositories/      # Repository implementations
│       │       └── [feature]_repository_impl.dart
│       │
│       ├── domain/                # Domain layer (Business Logic)
│       │   ├── entities/          # Business objects
│       │   │   └── [feature]_entity.dart
│       │   ├── repositories/      # Repository interfaces
│       │   │   └── [feature]_repository.dart
│       │   └── usecases/          # Use cases (Business rules)
│       │       └── get_[feature].dart
│       │
│       └── presentation/          # Presentation layer (UI)
│           ├── bloc/              # State management (BLoC)
│           │   ├── [feature]_bloc.dart
│           │   ├── [feature]_event.dart
│           │   └── [feature]_state.dart
│           ├── pages/             # Screen widgets
│           │   └── [feature]_page.dart
│           └── widgets/           # Feature-specific widgets
│               └── [feature]_widget.dart
│
├── injection/                     # Dependency Injection
│   └── injection_container.dart  # GetIt service locator setup
│
└── main.dart                      # App entry point
```

## Architecture Layers

### 1. **Presentation Layer** (`presentation/`)
- **Responsibility**: UI and user interactions
- **Components**: Pages, Widgets, BLoC (State Management)
- **Dependencies**: Domain layer only
- **No dependencies on**: Data layer, external frameworks (except Flutter)

### 2. **Domain Layer** (`domain/`)
- **Responsibility**: Business logic and rules
- **Components**: Entities, Use Cases, Repository Interfaces
- **Dependencies**: None (Pure Dart)
- **No dependencies on**: Flutter, Data layer, External packages

### 3. **Data Layer** (`data/`)
- **Responsibility**: Data retrieval and caching
- **Components**: Data Sources, Models, Repository Implementations
- **Dependencies**: Domain layer
- **Can use**: External packages (Dio, Hive, SharedPreferences, etc.)

## Key Principles

### Dependency Rule
- **Inner layers** (Domain) don't know about **outer layers** (Data, Presentation)
- **Dependencies point inward** toward the Domain layer
- Domain layer is **framework-independent**

### Separation of Concerns
- Each layer has a **single responsibility**
- Business logic is isolated from UI and data sources
- Easy to test and maintain

### Dependency Injection
- Uses **GetIt** for service locator pattern
- All dependencies are registered in `injection_container.dart`
- Makes testing easier with mock implementations

## Data Flow

```
UI (Presentation)
    ↓ (triggers event)
BLoC
    ↓ (calls)
Use Case
    ↓ (calls)
Repository Interface (Domain)
    ↓ (implemented by)
Repository Implementation (Data)
    ↓ (uses)
Data Sources (Remote/Local)
    ↓ (returns)
Entity (Domain)
    ↓ (mapped to)
Model (Data)
    ↓ (returns)
State (Presentation)
    ↓ (updates)
UI
```

## Adding a New Feature

1. **Create feature folder** in `lib/features/[feature_name]/`

2. **Domain Layer** (Start here - no dependencies):
   - Create `domain/entities/[feature]_entity.dart`
   - Create `domain/repositories/[feature]_repository.dart` (interface)
   - Create `domain/usecases/get_[feature].dart`

3. **Data Layer**:
   - Create `data/models/[feature]_model.dart` (extends entity)
   - Create `data/datasources/[feature]_remote_datasource.dart`
   - Create `data/datasources/[feature]_local_datasource.dart`
   - Create `data/repositories/[feature]_repository_impl.dart`

4. **Presentation Layer**:
   - Create `presentation/bloc/[feature]_bloc.dart`
   - Create `presentation/bloc/[feature]_event.dart`
   - Create `presentation/bloc/[feature]_state.dart`
   - Create `presentation/pages/[feature]_page.dart`
   - Create `presentation/widgets/[feature]_widget.dart` (if needed)

5. **Register dependencies** in `injection/injection_container.dart`

6. **Add route** in `core/routes/app_routes.dart` (if needed)

## Dependencies Used

- **dartz**: Functional programming (`Either` type for error handling)
- **equatable**: Value equality for entities and states
- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **dio**: HTTP client for API calls

## Testing Strategy

- **Unit Tests**: Test Use Cases, Repositories, Data Sources
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete feature flows

## Example Feature

See `features/example/` for a complete implementation example following this architecture.

