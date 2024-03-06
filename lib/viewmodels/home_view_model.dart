// viewmodels/home_view_model.dart
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final unfocusNode = FocusNode();

  late PageController pageController1;
  late PageController pageController2;

  int _pageIndex1 = 0;

  int get pageIndex1 => _pageIndex1;

  int _pageIndex2 = 0;

  int get pageIndex2 => _pageIndex2;

  int scrap = 00000000;

  bool get canUnfocus => unfocusNode.canRequestFocus;

  void onPageChanged1(int index) {
    _pageIndex1 = index;
    notifyListeners();
  }

  void onPageChanged2(int index) {
    _pageIndex2 = index;
    notifyListeners();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    pageController1.dispose();
    pageController2.dispose();
    super.dispose();
  }
}
