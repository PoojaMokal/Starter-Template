import 'package:go_router/go_router.dart';

import '../features/login/presentation/screens/login_screen.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import 'route_path.dart';

/// Pass objects between screens via `extra`, e.g.
/// `builder: (_, state) => DetailScreen(item: state.extra! as Item)`.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePath.splash.path,
    routes: [
      GoRoute(
        path: RoutePath.splash.path,
        name: RoutePath.splash.name,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePath.login.path,
        name: RoutePath.login.name,
        builder: (_, _) => const LoginScreen(),
      ),
    ],
  );
}
