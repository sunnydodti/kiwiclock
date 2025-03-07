import 'package:go_router/go_router.dart';
import 'package:kiwiclock/data/constants.dart';
import 'package:kiwiclock/pages/home_page.dart';
import 'package:kiwiclock/pages/stop_watch_page.dart';
import 'package:kiwiclock/pages/stopwatch_view_page.dart';

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
          final id = state.uri.queryParameters['id'];
          if (id == null) return StopWatchPage();
          return StopwatchViewPage(id: id);
        },
        routes: [
          GoRoute(
            name: 'Stopwatch View',
            path: '/:id',
            builder: (context, state) {
              return StopwatchViewPage(id: state.pathParameters['id']!);
            },
          )
        ]);
  }
}
