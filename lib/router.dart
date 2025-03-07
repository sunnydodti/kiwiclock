import 'package:go_router/go_router.dart';
import 'package:kiwiclock/data/constants.dart';
import 'package:kiwiclock/pages/home_page.dart';
import 'package:kiwiclock/pages/stop_watch_page.dart';

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
            _stopwatchRoute(),
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
  
  static GoRoute _stopwatchRoute() {
    return GoRoute(
      name: 'Stopwatch',
      path: '/stopwatch',
      builder: (context, state) {
        return StopWatchPage();
      },
    );
  }
}
