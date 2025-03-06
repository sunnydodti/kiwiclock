import 'package:flutter/material.dart';

class NavProvider extends ChangeNotifier {
  int _index = 1;

  int get index => _index;

  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
