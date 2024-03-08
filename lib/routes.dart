  //   // static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  // // static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  // static final _router = GoRouter(
  //   initialLocation: kIsWeb ? "/dashboard" : '/',
  //   routes: [
  //     GoRoute(path: '/', builder: (context, state) => BottomNavigation()),
  //     GoRoute(
  //       path: "/home",
  //       builder: (context, state) => HomeScreen(),
  //     ),
  //     GoRoute(
  //       path: '/rates',
  //       builder: (context, state) => RatesScreen(),
  //     ),
  //     GoRoute(
  //       path: "/schedule",
  //       builder: (context, state) => ScheduleScreen(),
  //     ),
  //     GoRoute(
  //       path: "/pickup",
  //       builder: (context, state) => PickUpScreen(),
  //     ),
  //     GoRoute(
  //       path: '/profile',
  //       builder: (context, state) => scrape_ui.ProfileScreen(),
  //     ),
  //     if (kIsWeb)
  //       GoRoute(
  //         path: '/dashboard',
  //         builder: (context, state) => Dashboard(),
  //       ),
  //     if (kIsWeb)
  //       GoRoute(
  //         path: "/rates_updater",
  //         builder: (context, state) => RatesScreen(),
  //       ),

  //     // if (kIsWeb) GoRoute(path: "/orders"),
  //     GoRoute(
  //       path: '/sign-in',
  //       builder: (context, state) => SignInScreen(
  //         providers: [EmailAuthProvider()],
  //         actions: [
  //           AuthStateChangeAction<SignedIn>(
  //             (context, _) {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute<ProfileScreen>(
  //                   builder: (context) => ProfileScreen(
  //                     appBar: AppBar(
  //                       title: const Text('User Profile'),
  //                     ),
  //                     actions: [
  //                       SignedOutAction(
  //                         (context) {
  //                           Navigator.of(context).pop();
  //                         },
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     )
  //   ],
  // );
