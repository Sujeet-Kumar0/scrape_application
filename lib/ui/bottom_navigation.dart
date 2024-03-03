import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrape_application/viewmodels/bottom_navigation_model.dart';

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomNavigationViewModel(),
      child: BottomNavigationWidget(),
    );
  }
}

class BottomNavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BottomNavigationViewModel>(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: false,
        bottom: true,
        child: IndexedStack(
          index: viewModel.selectedIndex,
          children: viewModel.pages,
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // height: 50,
          elevation: 5,
          indicatorColor: Colors.white.withOpacity(0.5),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        child: NavigationBar(
          // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: viewModel.selectedIndex,
          onDestinationSelected: viewModel.updateSelectedIndex,
          backgroundColor: Theme.of(context).colorScheme.background,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.book),
              icon: Icon(Icons.book_outlined),
              label: 'Rates',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.done_all),
              icon: Icon(Icons.done_all_outlined),
              label: 'Schedule',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.local_shipping),
              icon: Icon(Icons.local_shipping_outlined),
              label: 'Pick-Up',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person_2),
              icon: Icon(Icons.person_2_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
