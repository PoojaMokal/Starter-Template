# AGENTS.md

Guide for humans and AI agents working in this repo. Read this before adding code.

## Stack

| Concern | Choice |
|---|---|
| Architecture | Clean Architecture, feature-first (`data` / `domain` / `presentation`) |
| State | `flutter_bloc` (BLoC dominant, Cubits only for light UI state). `hooks_riverpod` provides only the root `ProviderScope`. |
| DI | `get_it` + `injectable` (codegen) |
| Networking | `dio` + `retrofit` (one service), `talker_dio_logger` in debug |
| Errors | `dartz` `Either<ApiFailure, T>` |
| Models | `freezed` + `json_serializable` |
| Navigation | `go_router` + `RoutePath` enum |
| Storage | `flutter_secure_storage` via `StorageManager`; in-memory via `TemporaryCacheManager` |

## Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after ANY annotated change
dart run build_runner watch                                 # while developing
dart run tool/generate_assets.dart                          # after adding images to assets/images/
flutter analyze
flutter test
```

> Generated files (`*.g.dart`, `*.freezed.dart`, `*.config.dart`) are git-ignored, so run
> `build_runner` after every clone/pull. Recent `build_runner` versions ignore
> `--delete-conflicting-outputs` with a warning; that's harmless.

## Layout

```
lib/
  main.dart            Firebase init → configureDependencies() → runApp(ProviderScope(App()))
  app.dart             MaterialApp.router + ScreenUtilInit + theme
  core/
    constants/         color/, image/ (GENERATED), strings/
    dependency/        injection.dart, injection.config.dart (GENERATED), firebase_remote_config.dart
    errors/            api_failure.dart (server | network | unauthorized | unknown)
    extensions/        BuildContext / String extensions
    helper/            session_manager, device_information_helper, app_logger
    network/           api_client, api_endpoints, network_info, interceptors/, services/api_service.dart
    storage/           storage_keys (enum), storage_manager, temporary_cache_manager
    usecases/          UseCase<T, Params>, NoParams
    utils/             role_utils, formatters/
    widgets/           shared small widgets (AppButton, AppTextField)
  models/base_response/ BaseResponse<T> envelope
  routes/              route_path.dart (enum), app_router.dart
  widgets/             custom_scaffold.dart
  features/<feature>/
    data/        datasources/ models/ repositories/
    domain/      repositories/ usecases/
    presentation/ bloc/ screens/
tool/generate_assets.dart   ImageConstants generator (flutter_assets, Windows-safe)
```

## Request flow

```
Screen ──event──▶ Bloc ──▶ UseCase ──▶ Repository (abstract, domain)
                                          │
                              RepositoryImpl (data) ──▶ RemoteDataSource ──▶ ApiService (Retrofit)
                                                                                 │
                    Dio: InternetConnectionChecker → SimCheck → Encryption → TalkerDioLogger
```

- `ApiService` returns `BaseResponse<T>`. Wire keys: `s` status, `p` payload, `h` header, `c` code.
  The decrypted body is `p.rb` → `response.body`.
- `RepositoryImpl` catches `DioException` → `ApiFailure.fromDioException(e)`, and anything else
  → `ApiFailure.unknown()`. Repositories and use cases never throw.
- Use cases always return `Future<Either<ApiFailure, T>>`.

## Rules

1. **Models**: `@freezed` + json_serializable, with `part 'x.freezed.dart'; part 'x.g.dart';`.
   Use `abstract class` for data classes and `sealed class` for unions (freezed 3).
2. **DI annotations**
   - BLoCs / Cubits / use cases → `@injectable` (new instance per request)
   - services, managers, interceptors → `@lazySingleton`
   - interface implementations → `@LazySingleton(as: Abstract)`
   - third-party types → add a getter/method to `RegisterModule` in `injection.dart`
   - Never hand-edit `injection.config.dart`.
3. **BLoCs** are only obtained with `getIt` inside a screen-level `BlocProvider`:
   `BlocProvider(create: (_) => getIt<XBloc>()..add(const XEvent.started()))`.
   Never `XBloc(...)` inline. Events/states are `@freezed` `part of` the bloc file.
4. **Navigation**: only `context.go(RoutePath.x.path)` / `context.push(RoutePath.x.path, extra: obj)`.
   Add a value to `RoutePath` and a `GoRoute` in `AppRouter` for every new screen.
5. **Encryption**: never encrypt/decrypt in features. `EncryptionInterceptor` does it for every
   request/response.
6. **Endpoints**: every endpoint goes in the single `ApiService`; paths are constants in `ApiEndpoints`.
7. **Storage**: persisted values go through `StorageManager` with a `StorageKey`; session-only values
   use `TemporaryCacheManager` or `SessionManager`.
8. **Assets**: drop files in `assets/images/<folder>/`, run `dart run tool/generate_assets.dart`, and use
   `ImageConstants.x`. Don't hard-code asset paths.

## Environment switch

`lib/core/network/api_endpoints.dart`:

```dart
static const String env = 'local'; // 'local' | 'UAT'
```

`baseUrl` switches on `env`. Self-signed certificates are accepted only when
`kDebugMode && env == 'local'`.

## Adding a feature (copy `login`)

1. `data/models/` request/response DTOs (freezed).
2. Add the endpoint constant to `ApiEndpoints` and the method to `ApiService`.
3. `data/datasources/<feature>_remote_datasource.dart`: abstract + `@LazySingleton(as:)` impl.
4. `domain/repositories/<feature>_repository.dart`: abstract.
5. `data/repositories/<feature>_repository_impl.dart`: `@LazySingleton(as:)`, maps errors.
6. `domain/usecases/<action>_usecase.dart`: `@injectable`, one per action.
7. `presentation/bloc/`: bloc + event + state (freezed), `@injectable`.
8. `presentation/screens/`: `BlocProvider(create: (_) => getIt<XBloc>())`.
9. Add a `RoutePath` value and `GoRoute`.
10. Run `build_runner`, `flutter analyze`, and `flutter test`. Add a use case test with a mocked repository
    (see `test/features/login/`).

## Key files

| File | Purpose |
|---|---|
| `lib/main.dart` | Bootstrap: Firebase, Crashlytics, DI, Remote Config, `ProviderScope` |
| `lib/core/dependency/injection.dart` | `getIt`, `configureDependencies()`, `RegisterModule` (Dio, secure storage, ApiService) |
| `lib/core/network/api_client.dart` | Dio options, timeouts, interceptor order, dev certificate bypass |
| `lib/core/network/api_endpoints.dart` | `env` switch, base URLs, endpoint paths |
| `lib/core/network/services/api_service.dart` | The single Retrofit service |
| `lib/core/network/interceptors/encryption_interceptor.dart` | Transparent payload encryption + `PayloadCipher` stub |
| `lib/core/errors/api_failure.dart` | Failure union + `fromDioException` |
| `lib/models/base_response/base_response.dart` | Response envelope (`s`/`p`/`h`/`c`, `p.rb`) |
| `lib/core/storage/storage_manager.dart` | Secure storage by `StorageKey` |
| `lib/core/helper/session_manager.dart` | In-memory token / CIF |
| `lib/routes/route_path.dart`, `app_router.dart` | Routes |
| `lib/widgets/custom_scaffold.dart` | Common scaffold with loader overlay |
| `lib/features/login/` | Reference feature, all layers |
| `tool/generate_assets.dart` | Generates `ImageConstants` |
