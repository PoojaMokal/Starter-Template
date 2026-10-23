# starter_project

A new Flutter project.

## Getting Started

# Flutter Clean Architecture Starter

A reusable Flutter project template designed to build scalable, maintainable, and testable mobile applications using **Clean Architecture and BLoC state management**.

The project provides a modular foundation with clearly separated data, domain, and presentation layers, making it easy to add new features while keeping business logic independent of the UI and networking implementation.

## Key Features

- **Clean Architecture** — Separate data, domain, and presentation layers.
- **BLoC State Management** — Structured event-driven state management using `flutter_bloc` and Freezed.
- **Dependency Injection** — Centralized dependency registration with GetIt and Injectable.
- **API Integration** — Retrofit and Dio for REST API communication.
- **Error Handling** — Consistent error management using `Either` and custom `ApiFailure` types.
- **Navigation** — Declarative routing with GoRouter.
- **Data Models** — Immutable models and JSON serialization using Freezed and `json_serializable`.
- **Secure Storage** — Centralized secure storage and session management.
- **Network Infrastructure** — Interceptors for connectivity checks, device/SIM checks, and encryption integration.
- **Firebase Integration** — Foundation for Remote Config, Cloud Messaging, and Crashlytics.
- **Reusable UI Components** — Shared widgets, themes, colors, assets, and responsive layouts.
- **Environment Configuration** — Switchable local and UAT API environments.
- **Testing and Code Generation** — Build Runner setup and unit testing support.

## Sample Feature

The starter includes a Splash-to-Login flow demonstrating the intended feature implementation pattern:

`Screen → BLoC → Use Case → Repository → Data Source → API Service`

Successful login is designed to persist the authentication token through the storage and session management layers.

## Getting Started

1. Install the required Flutter SDK.
2. Configure the API base URLs, encryption keys, and Firebase platform configuration.
3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Generate the required code:

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. Run static analysis and tests:

   ```bash
   flutter analyze
   flutter test
   ```

## Architecture Guidelines

- Keep business logic inside domain use cases and repositories.
- Obtain BLoCs through the configured dependency injection container.
- Keep API communication inside the shared service and data layers.
- Use consistent failure types across feature implementations.
- Use code generation for immutable models and serialization.
- Keep environment-specific configuration separate from feature logic.

## Security Notes

Configure real encryption algorithms and key management before production use. Validate certificate handling, authentication, secure storage, and environment configuration before releasing the application.

## Purpose

This repository serves as a reusable foundation for Flutter applications, helping developers follow consistent architectural patterns and add new features without duplicating core infrastructure.
