/// Every route in the app. Navigate with `context.go(RoutePath.x.path)`
/// or `context.push(RoutePath.x.path, extra: object)`.
enum RoutePath {
  splash('/splash'),
  login('/login');

  const RoutePath(this.path);

  final String path;
}
