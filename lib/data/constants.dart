import 'package:flutter/material.dart';

class Constants {
  static String box = 'kiwiclock_box';

  static String isDarkMode = 'isDarkMode';

  static String isActiveKey = 'is_active';
  static String currentDataKey = 'current_data';
  static String indexKey = 'index';

  static String stopwatchEventsKey = 'stopwatch_histories';
  static String currentStopwatchEventKey = 'current_ stopwatch_event';

  static String stopwatchTable = 'stopwatch';

  static final appShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'app shell');

  static String url = 'kiwiclock.persist.site';
  static String baseUrl = 'https://$url';
}
