import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrape_application/viewmodels/bottom_navigation_model.dart';
import 'package:scrape_application/viewmodels/home_view_model.dart';

import '../components/utils.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart'
//     as smooth_page_indicator;

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
  int _currentPage = 0;

  // late BottomNavigationViewModel _bottomNavigationViewModel;

  @override
  void initState() {
    _model = HomeViewModel();

    _model.pageController1 = PageController(initialPage: 0);
    _scrollController = ScrollController()..addListener(_scrollListener);

    // Ensure that the PageController is attached to a scroll view
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _startTimer();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _model.dispose();
    _scrollController.dispose();
    _timer.cancel();

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Reached the end of scroll
      _model.loadMoreAdBanners();
    }
  }

  void _startTimer() {
    const duration = Duration(seconds: 3);
    _timer = Timer.periodic(
      duration,
      (timer) {
        if (_currentPage < _model.adBanners.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_model.pageController1.hasClients) {
          // Check if the controller is attached
          _model.pageController1.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        }
      },
    );
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
              Positioned.fill(
                child: Image.asset(
                  "assets/images/Blue Gradient.png",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
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
                                0, 0, 0, 8),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                image: DecorationImage(
                                    // fit: BoxFit.cover,
                                    image: Image.asset(
                                  'assets/images/test_logo.png',
                                  width: 0,
                                  height: 101,
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
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 8, 0, 8),
                            child: ElevatedButton(
                              onPressed: () async {
                                // const snackBar = SnackBar(
                                //   content: Text('Button Pressed'),
                                //   duration: Duration(seconds: 3),
                                // );

                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(snackBar);
                                // // context.pushReplacement('/schedule');
                                bottomNavigationViewModel
                                    .updateSelectedIndex(2);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24, 0, 24, 0),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'SCHEDULE A PICK-UP',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                          // this is the ad Banners
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              itemCount: _model.adBanners.length,
                              itemBuilder: (context, index) {
                                if (index == _model.adBanners.length - 1) {
                                  return buildProgressIndicator();
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            _model.adBanners[index].imageUrl,
                                        width: 250,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          Text(
                            "Our Impact",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.primaries.last),
                          ),

                          const SizedBox(height: 10),

                          Container(
                            height: 200,
                            alignment: const AlignmentDirectional(0, -0.8),
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${_model.scrap} /KG',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  TextSpan(
                                      text: '\n Has been sold',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium)
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
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
