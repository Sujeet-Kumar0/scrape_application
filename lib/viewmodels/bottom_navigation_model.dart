import 'package:flutter/material.dart';
import 'package:scrape_application/ui/home_screen.dart';
import 'package:scrape_application/ui/pickup.dart';
import 'package:scrape_application/ui/profile.dart';
import 'package:scrape_application/ui/rates_screen.dart';
import 'package:scrape_application/ui/schedule.dart';

class BottomNavigationViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    RatesScreen(),
    ScheduleScreen(),
    PickUpScreen(),
    ProfileScreen()
  ];

  int get selectedIndex => _selectedIndex;

  List<Widget> get pages => _pages;

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
