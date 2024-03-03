import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scrape_application/ui/bottom_navigation.dart';
import 'package:scrape_application/ui/home_screen.dart';
import 'package:scrape_application/ui/pickup.dart';
import 'package:scrape_application/ui/profile.dart' as scrape_ui;
import 'package:scrape_application/ui/rates_screen.dart';
import 'package:scrape_application/ui/schedule.dart';
import 'package:scrape_application/ui/theme.dart';

import 'firebase_options.dart';
import 'viewmodels/profile_view_model.dart';
import 'viewmodels/rates_screen_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  // static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final _router = GoRouter(initialLocation: '/', routes: [
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
    // GoRoute(
    //   path: '/profile',
    //   builder: (context, state) => ProfileScreen(
    //     providers: [EmailAuthProvider()],
    //   ),
    // ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => SignInScreen(
        providers: [EmailAuthProvider()],
        actions: [
          AuthStateChangeAction<SignedIn>((context, _) {
            Navigator.push(
              context,
              MaterialPageRoute<ProfileScreen>(
                builder: (context) => ProfileScreen(
                  appBar: AppBar(
                    title: const Text('User Profile'),
                  ),
                  actions: [
                    SignedOutAction((context) {
                      Navigator.of(context).pop();
                    })
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    )
  ]);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider<RatesScreenViewModel>(
            create: (context) => RatesScreenViewModel())
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: myTheme,
        // ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
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
