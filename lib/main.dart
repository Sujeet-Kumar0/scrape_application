import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scrape_application/ui/login_screen.dart';
import 'package:scrape_application/ui/sign_up.dart';
import 'package:scrape_application/ui/theme.dart';
import 'package:scrape_application/ui/web/dashboard.dart';
import 'package:scrape_application/ui/web/orders_screen.dart';
import 'package:scrape_application/viewmodels/login_viewmodel.dart';
import 'package:scrape_application/viewmodels/pickup_viewmodel.dart';
import 'package:scrape_application/viewmodels/saved_address_viewmodel.dart';
import 'package:scrape_application/viewmodels/schedule_viewmodel.dart';
import 'package:scrape_application/viewmodels/signup_viewmodel.dart';

import 'firebase_options.dart';
import 'ui/bottom_navigation.dart';
import 'ui/home_screen.dart';
import 'ui/pickup.dart';
import 'ui/profile.dart' as scrape_ui;
import 'ui/rates_screen.dart';
import 'ui/schedule.dart';
import 'ui/web/rates_update_screen.dart';
import 'viewmodels/profile_view_model.dart';
import 'viewmodels/rates_screen_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  // static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final _router = GoRouter(
    initialLocation: kIsWeb ? "/dashboard" : '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => BottomNavigation()),
      GoRoute(
        path: "/home",
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/rates',
        builder: (context, state) => RatesScreen(),
      ),
      GoRoute(
        path: "/schedule",
        builder: (context, state) => ScheduleScreen(),
      ),
      GoRoute(
        path: "/pickup",
        builder: (context, state) => PickUpScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => scrape_ui.ProfileScreen(),
      ),
      if (kIsWeb)
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => Dashboard(),
        ),
      if (kIsWeb)
        GoRoute(
          path: "/rates_updater",
          builder: (context, state) => RatesUpdateScreen(),
        ),
      if (kIsWeb)
        GoRoute(
          path: "/orders",
          builder: (context, state) => OrdersScreen(),
        ),
      GoRoute(
        path: "/login",
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: "/sign-up",
        builder: (context, state) => SignUpScreen(),
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider<RatesScreenViewModel>(
            create: (context) => RatesScreenViewModel()),
        ChangeNotifierProvider(create: (context) => ScheduleViewModel()),
        ChangeNotifierProvider(create: (context) => PickupViewModel()),
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => SignupViewModel()),
        ChangeNotifierProvider(create: (context) => AddressViewModel())
      ],
      child: MaterialApp.router(
        // debugShowCheckedModeBanner: false,

        title: 'Flutter Demo',
        theme: myTheme,
        routerConfig: _router,
      ),
    );
  }
}

// final routes = GoRouter(
// initialLocation: homePage,
// routes: [
// GoRoute(
// pageBuilder: (context, state) => CustomTransitionPage<void>(
// key: state.pageKey,
// child: AuthPage(),
// transitionsBuilder: (context, animation, secondaryAnimation, child) =>
// FadeTransition(opacity: animation, child: child),
// ),
// path: authPage,
// ),
// GoRoute(
// pageBuilder: (context, state) => CustomTransitionPage<void>(
// key: state.pageKey,
// child: HomePage(),
// transitionsBuilder: (context, animation, secondaryAnimation, child) =>
// FadeTransition(opacity: animation, child: child),
// ),
// path: homePage,
// ),
