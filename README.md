# base_project

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

prompt
# Task: Scaffold a new Flutter project with Clean Architecture + BLoC
Create a new Flutter app named `<app_name>` (org: `<com.company>`), Dart SDK ^3.7.2.
Set up the full project skeleton, core infrastructure, and ONE working sample feature
(`splash` → `login`) so the pattern can be copied for future features.
Do NOT add business features beyond the sample.
## 1. Create project
flutter create --org <com.company> --project-name <app_name> .
## 2. Dependencies (pubspec.yaml)
dependencies:
flutter_bloc, bloc, equatable           # state management (BLoC dominant)
hooks_riverpod, flutter_hooks           # ProviderScope at root only
dio, retrofit, logger, talker_dio_logger # networking
dartz                                   # Either<Failure, T>
get_it, injectable                      # DI
freezed_annotation, json_annotation     # models
go_router                               # navigation
flutter_secure_storage                  # persisted storage
encrypt, pointycastle, crypto           # encryption
internet_connection_checker_plus
device_info_plus, package_info_plus, flutter_udid, safe_device
flutter_screenutil, flutter_svg, google_fonts, lottie, intl
firebase_core, firebase_remote_config, firebase_messaging, firebase_crashlytics
flutter_native_splash
dev_dependencies:
build_runner, freezed, json_serializable, retrofit_generator,
injectable_generator, flutter_lints, flutter_launcher_icons, flutter_assets
Use the latest compatible versions and make sure `flutter pub get` succeeds.
Configure `flutter_assets` to generate `lib/core/constants/image/image_constants.dart`
(class `ImageConstants`) from `assets/images/`.
## 3. Folder structure (lib/)
lib/
main.dart                      # init Firebase, configureDependencies(), runApp(ProviderScope(child: App()))
app.dart                       # MaterialApp.router + ScreenUtilInit + theme
core/
constants/
color/                     # app_colors.dart, role_colors.dart
image/                     # generated image_constants.dart
strings/                   # app_strings.dart
dependency/
injection.dart             # @InjectableInit, configureDependencies(), @module RegisterModule (Dio, FlutterSecureStorage)
injection.config.dart      # GENERATED, never hand-edit
firebase_remote_config.dart
errors/                      # api_failure.dart (freezed union: server, network, unauthorized, unknown)
extensions/                  # context/string extensions
helper/                      # session_manager.dart (singleton: token, CIF), device_information_helper.dart
network/
api_client.dart            # Dio setup, timeouts, interceptors, badCertificateCallback (dev)
api_endpoints.dart         # static `env` ('local' | 'UAT') -> baseUrl switch + endpoint constants
network_info.dart
interceptors/
encryption_interceptor.dart          # encrypt request body / decrypt response transparently
internet_connection_checker_interceptor.dart
sim_check_interceptor.dart           # active only when !kDebugMode (stub logic)
services/
api_service.dart         # SINGLE @RestApi Retrofit service for ALL endpoints
storage/
storage_keys.dart          # enum StorageKey
storage_manager.dart       # wraps FlutterSecureStorage, read/write/delete by StorageKey
temporary_cache_manager.dart # @lazySingleton in-memory map for session-only data
usecases/
usecase.dart               # abstract UseCase<Type, Params> { Future<Either<ApiFailure, Type>> call(Params) }; NoParams
utils/
role_utils.dart            # getDisplayRole(raw): maker->Maker, checker->Checker, lcra/lcru->Dual
formatters/
widgets/                     # shared reusable widgets
models/
base_response/
base_response.dart         # freezed; short keys: s (status), p (payload, with rb = decrypted body), h (header), c (code)
routes/
route_path.dart              # enum RoutePath { splash('/splash'), login('/login'), ... ; final String path; }
app_router.dart              # GoRouter with routes built from RoutePath; pass objects via `extra`
widgets/
custom_scaffold.dart         # common scaffold (app bar, background, loader overlay)
features/
<feature>/
data/
datasources/             # <feature>_remote_datasource.dart (calls ApiService)
models/                  # freezed + json_serializable request/response DTOs
repositories/            # <feature>_repository_impl.dart  @LazySingleton(as: <Feature>Repository)
domain/
repositories/            # abstract <Feature>Repository
usecases/                # one class per action, @injectable, returns Either<ApiFailure, T>
presentation/
bloc/                    # <feature>_bloc.dart, _event.dart, _state.dart (all @freezed), BLoC is @injectable
screens/                 # UI; BlocProvider(create: (_) => getIt<XBloc>()..add(...))
assets/
images/{background,logos,icons,placeholder}/
fonts/{Roboto,Inter}/
lottie/
## 4. Rules to follow
- Every model uses @freezed + json_serializable with
  `part 'x.freezed.dart'; part 'x.g.dart';`
- Use cases ALWAYS return `Future<Either<ApiFailure, T>>`. Repositories catch DioException
  and map it to ApiFailure.
- DI annotations: BLoCs → @injectable; services/managers → @lazySingleton;
  interface bindings → @LazySingleton(as: Abstract).
- BLoCs are only obtained via getIt inside a BlocProvider at screen level. Never create them inline.
- Navigation only via `context.go(RoutePath.x.path)` / `context.push(...)`.
- No manual encryption in features. EncryptionInterceptor handles it. Leave the encryption
  algorithm as a clearly marked TODO stub (AES placeholder) for me to fill in.
- Cubits are allowed for lightweight UI state (e.g. NavigationCubit for bottom nav).
## 5. Sample feature (end-to-end)
Implement `splash` and `login` features fully through all layers:
- Login: request model (userId, password) → ApiService.login → datasource → repository → LoginUseCase → LoginBloc
  (events: submitted; states: initial/loading/success/failure) → LoginScreen with form + loader + error snackbar.
- On success, save the token through StorageManager (StorageKey.token) and SessionManager.
- Splash navigates to login after 2s.
## 6. Also create
- `AGENTS.md` (and CLAUDE.md pointing to it) that documents this architecture, the DI/codegen rules,
  the env switch, and a key-files table.
- `analysis_options.yaml` with flutter_lints that excludes `**/*.g.dart`, `**/*.freezed.dart`, `**/*.config.dart`.
- `.gitignore` entries for generated/build files as appropriate.
## 7. Verify
Run these in order and fix all errors:
1. flutter pub get
2. dart run build_runner build --delete-conflicting-outputs
3. flutter analyze   (zero errors)
4. flutter test      (add one unit test for LoginUseCase using a mocked repository)
   Finish with a summary: the files you created, and the TODOs I still have to fill in
   (encryption keys, base URLs, Firebase config/google-services.json).
5.  Firebase: Run flutterfire configure yourself afterwards, or remove the Firebase lines if you don't need it on day one.
   Encryption and SIM binding: The prompt leaves these as stubs on purpose. You can copy the real code from this repo's lib/core/network/interceptors/ if the new project uses the same backend contract.
   Dependencies: To keep the same package versions as this project, replace section 2 with "use the exact versions from this pubspec:" and paste the dependencies from pubspec.yaml.
