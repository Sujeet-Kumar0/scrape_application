import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrape_application/viewmodels/bottom_navigation_model.dart';
import 'package:scrape_application/viewmodels/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late HomeViewModel _model;
  late ScrollController _scrollController;
  late Timer _timer;
  double _currentPage = 0;

  // late BottomNavigationViewModel _bottomNavigationViewModel;

  @override
  void initState() {
    _model = HomeViewModel();
    _scrollController = ScrollController();

    // Start the timer when the widget is first built
    _startTimer();

    // Add listener to stop the timer when the user starts scrolling manually
    _scrollController.addListener(_stopTimer);

    super.initState();
  }

  @override
  void dispose() {
    _model.dispose();
    _scrollController.dispose();
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const duration = Duration(seconds: 3);
    _timer = Timer.periodic(
      duration,
      (timer) {
        if (_model.adBanners.isNotEmpty) {
          if (_currentPage < _model.adBanners.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0.0;
          }
          if (_scrollController.hasClients) {
            // Check if the controller is attached
            _scrollController.animateTo(
              _currentPage * 300, // Assuming each item width is 300
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          }
        }
      },
    );
  }

  void _stopTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  void _restartTimer() {
    // Restart the timer when the user stops scrolling
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    var bottomNavigationViewModel =
        Provider.of<BottomNavigationViewModel>(context);
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              // Background image positioned behind other widgets
              // Positioned.fill(
              //   child: Image.asset(
              //     "assets/images/Blue Gradient.png",
              //     fit: BoxFit.cover,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 16),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                image: DecorationImage(
                                    // fit: BoxFit.cover,
                                    image: Image.asset(
                                  'assets/images/Scrap.png',
                                  width: 0,
                                  // height: 101,
                                  fit: BoxFit.contain,
                                ).image),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 12,
                                    color: Color(0x33000000),
                                    offset: Offset(0, 5),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Text(
                            "Lets save Enviroment & Make",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Some Money",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextButton(
                                onPressed: () async {
                                  bottomNavigationViewModel
                                      .updateSelectedIndex(2);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  // padding: const EdgeInsets.symmetric(
                                  //     horizontal: 24),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Request Pick-Up',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ],
                          ),

                          Container(
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                0, 16, 0, 16),
                            height: 90,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              image: DecorationImage(
                                  // fit: BoxFit.cover,
                                  image: Image.asset(
                                'assets/images/Sell Your Scrap.png',
                                width: 0,
                                // height: 101,
                                fit: BoxFit.cover,
                              ).image),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 12,
                                  color: Color(0x33000000),
                                  offset: Offset(0, 5),
                                )
                              ],
                            ),
                          ),
                          // this is the ad Banners
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              itemCount: _model.adBanners.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          _model.adBanners[index].imageUrl,
                                      width: 300,
                                      height: 10,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Text(
                            "Our Vision",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 20,
                                ),
                          ),

                          const SizedBox(height: 10),

                          ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: Container(
                                height: 120,
                                alignment: const AlignmentDirectional(0, 0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/design.png'), // Replace 'assets/background_image.jpg' with your image path
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                    width: 1.5,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${_model.scrap} /KG',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onTertiaryContainer),
                                      ),
                                      TextSpan(
                                        text: '\n Has been sold',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      )
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 70),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
