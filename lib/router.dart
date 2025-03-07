import 'package:go_router/go_router.dart';
import 'package:kiwiclock/data/constants.dart';
import 'package:kiwiclock/pages/home_page.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
          navigatorKey: Constants.appShellNavigatorKey,
          builder: (context, state, child) {
            return child;
          },
          routes: [
            _homeToute(),
          ])
    ],
  );

  static GoRoute _homeToute() {
    return GoRoute(
      name: 'Home',
      path: '/home',
      builder: (context, state) {
        return HomePage();
      },
    );
  }
}
