# Utakula Version 2: Your Personal Meal Planner

Utakula_V2 is a Flutter-based mobile application designed to simplify your meal planning and food management.
"Utakula!?" is Swahili for "What will you eat!?" perfectly encapsulating the app's mission to help you organize your culinary life.

## Features

*   **User Authentication:** Secure registration and login to personalize your experience.
*   **Comprehensive Meal Planning:** Create and manage daily meal plans with ease.
*   **Extensive Food & Recipe Database:** Explore a wide variety of foods and recipes, with a special focus on Kenyan cuisine (featuring dishes like Githeri, Mukimo, and Ugali).
*   **Custom Food Additions:** Personalize your database by adding your own unique food items.
*   **Smart Reminders:** Stay on track with timely meal reminders.
*   **Account Management:** Conveniently manage your profile and app settings.

## Technical Stack

*   **Framework:** Flutter
*   **State Management:** Riverpod
*   **Navigation:** GoRouter
*   **API Communication:** Dio

## Getting Started

### Prerequisites

*   Flutter SDK (latest stable version)
*   Dart SDK
*   Android Studio / Xcode (for mobile development)
*   A connected device or emulator

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/BernardMugita/utakula_v2.git
    cd utakula_v2
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the application:**
    ```bash
    flutter run
    ```
    This will launch the app on a connected device or emulator.

## Project Structure

```
utakula_v2/
│
├── lib/
│   ├── main.dart                      # Application entry point
│   │
│   ├── common/                        # Shared resources across features
│   │   ├── global_widgets/            # Reusable UI components
│   │   │   ├── utakula_button.dart
│   │   │   ├── utakula_input.dart
│   │   │   └── utakula_side_navigation.dart
│   │   ├── themes/                    # App theming configuration
│   │   │   └── theme_utils.dart
│   │   └── utils/                     # Utility functions and helpers
│   │       └── either.dart            # Functional programming utilities
│   │
│   ├── core/                          # Core application functionality
│   │   ├── error/                     # Error handling
│   │   │   ├── exceptions.dart        # Custom exceptions
│   │   │   └── failures.dart          # Failure types
│   │   ├── network/                   # Network layer
│   │   │   ├── api_endpoints.dart     # API endpoint constants
│   │   │   └── dio_client.dart        # Dio HTTP client configuration
│   │   ├── providers/                 # Global Riverpod providers
│   │   │   ├── session_provider.dart  # Session management provider
│   │   │   └── session_state_provider.dart
│   │   └── utils/                     # Core utilities
│   │       └── either.dart
│   │
│   ├── features/                      # Feature-based modules
│   │   │
│   │   ├── foods/                     # Food database feature (Clean Architecture)
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   │   └── foods_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── calorie_model.dart
│   │   │   │   │   └── food_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── foods_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── calorie_entity.dart
│   │   │   │   │   ├── food_entity.dart
│   │   │   │   │   └── meal_plan_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── foods_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       └── foods_use_cases.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── add_foods.dart
│   │   │       │   └── food.dart
│   │   │       ├── providers/
│   │   │       │   └── foods_provider.dart
│   │   │       └── widgets/
│   │   │           ├── food_banner.dart
│   │   │           ├── food_container.dart
│   │   │           └── food_search_box.dart
│   │   │
│   │   ├── homepage/                  # Home dashboard feature
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       └── widgets/
│   │   │
│   │   ├── login/                     # Login feature
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       ├── providers/
│   │   │       └── widgets/
│   │   │
│   │   ├── meal_plan/                 # Meal planning feature
│   │   │   ├── data/
│   │   │   │   ├── data_sources/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       ├── providers/
│   │   │       └── widgets/
│   │   │
│   │   └── register/                  # Registration feature
│   │       ├── data/
│   │       │   ├── data_sources/
│   │       │   ├── models/
│   │       │   └── repositories/
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   ├── repositories/
│   │       │   └── usecases/
│   │       └── presentation/
│   │           ├── pages/
│   │           ├── providers/
│   │           └── widgets/
│   │
│   └── routing/                       # Navigation configuration
│       ├── router_provider.dart       # GoRouter provider
│       └── routes.dart                # Route definitions
│
├── assets/                            # Static assets
│   ├── fonts/                         # Custom fonts
│   ├── ios/                           # iOS-specific assets
│   └── (food images and other resources)
│
├── test/                              # Unit and widget tests
│   ├── features/
│   └── common/
│
├── android/                           # Android-specific files
├── ios/                               # iOS-specific files
├── web/                               # Web-specific files
├── linux/                             # Linux-specific files
├── windows/                           # Windows-specific files
├── macos/                             # macOS-specific files
│
├── pubspec.yaml                       # Project dependencies
├── analysis_options.yaml              # Dart analyzer configuration
└── README.md                          # Project documentation
```

## Architecture

This project follows **Clean Architecture** principles with **Feature-First** organization:

### Layer Structure (per feature)

Each feature (foods, login, register, meal_plan, homepage) follows a consistent three-layer architecture:

#### 1. **Data Layer** (`data/`)
*   **data_sources/**: Remote API calls and local database operations
*   **models/**: Data transfer objects (DTOs) with JSON serialization
*   **repositories/**: Implementation of domain repository interfaces

#### 2. **Domain Layer** (`domain/`)
*   **entities/**: Pure business objects (no dependencies)
*   **repositories/**: Abstract repository interfaces
*   **usecases/**: Business logic and use case implementations

#### 3. **Presentation Layer** (`presentation/`)
*   **pages/**: Screen widgets and UI layouts
*   **providers/**: Riverpod state management providers
*   **widgets/**: Feature-specific reusable widgets

### Shared Resources

*   **common/**: Reusable widgets (`utakula_button`, `utakula_input`, `utakula_side_navigation`), themes, and utilities
*   **core/**: Error handling, network client (Dio), API endpoints, and global session providers
*   **routing/**: Centralized GoRouter configuration for app navigation

### Key Architecture Benefits

*   **Separation of Concerns**: Each layer has a single, well-defined responsibility
*   **Testability**: Business logic isolated from UI and external dependencies
*   **Scalability**: Easy to add new features following the established pattern
*   **Maintainability**: Clear structure makes navigation and updates straightforward
*   **Dependency Rule**: Dependencies point inward (presentation → domain ← data)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

Bernard Mugita - [@BernardMugita](https://github.com/BernardMugita)

Project Link: [https://github.com/BernardMugita/utakula_v2]