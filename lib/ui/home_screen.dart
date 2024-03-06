import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrape_application/viewmodels/bottom_navigation_model.dart';
import 'package:scrape_application/viewmodels/home_view_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late HomeViewModel _model;

  // late BottomNavigationViewModel _bottomNavigationViewModel;

  @override
  void initState() {
    _model = HomeViewModel();

    _model.pageController1 = PageController(initialPage: 0);
    _model.pageController2 = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
          child: Padding(
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
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
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
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                        child: ElevatedButton(
                          onPressed: () async {
                            // const snackBar = SnackBar(
                            //   content: Text('Button Pressed'),
                            //   duration: Duration(seconds: 3),
                            // );

                            // ScaffoldMessenger.of(context)
                            //     .showSnackBar(snackBar);
                            // // context.pushReplacement('/schedule');
                            bottomNavigationViewModel.updateSelectedIndex(2);
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
                                .titleSmall!
                                .copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                      // this is the first ad Banners
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                          child: SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 40),
                                  child: PageView(
                                    clipBehavior: Clip.none,
                                    padEnds: true,
                                    controller: _model.pageController1,
                                    onPageChanged: _model.onPageChanged1,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://picsum.photos/seed/676/600',
                                          width: 320,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://picsum.photos/seed/645/600',
                                          width: 320,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://picsum.photos/seed/143/600',
                                          width: 320,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(0, 0.8),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 0, 16),
                                    child: smooth_page_indicator
                                        .SmoothPageIndicator(
                                      controller: _model.pageController1,
                                      count: 3,
                                      axisDirection: Axis.horizontal,
                                      onDotClicked: (i) async {
                                        await _model.pageController1
                                            .animateToPage(
                                          i,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        );
                                      },
                                      effect: smooth_page_indicator
                                          .ExpandingDotsEffect(
                                        expansionFactor: 3,
                                        spacing: 8,
                                        radius: 12,
                                        dotWidth: 6,
                                        dotHeight: 6,
                                        dotColor: Colors.purpleAccent,
                                        activeDotColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        paintStyle: PaintingStyle.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 12,
                              color: Color(0x33000000),
                              offset: Offset(0, 5),
                            )
                          ],
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary
                            ],
                            stops: const [0, 1],
                            begin: const AlignmentDirectional(1, 1),
                            end: const AlignmentDirectional(1, -1.31),
                          ),
                          borderRadius: BorderRadius.circular(6),
                          // shape: BoxShape.rectangle,
                        ),
                        alignment: const AlignmentDirectional(0, 0),
                        child: RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${_model.scrap} Has been sold',
                              )
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
/*                      const Text(
                        "Image Gallery",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Divider(
                        height: 2,
                        thickness: 1,
                        indent: 5,
                        endIndent: 50,
                      ),
                      const SizedBox(height: 10),
*/
                      /*Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 16, 0, 0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 550,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 50),
                                  child: PageView(
                                    controller: _model.pageController2,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 16, 0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://picsum.photos/seed/676/600',
                                            width: double.infinity,
                                            height: 500,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 8, 0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://picsum.photos/seed/645/600',
                                            width: 300,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8, 0, 0, 0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://picsum.photos/seed/143/600',
                                            width: 300,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(0, 0.6),
                                  child:
                                      smooth_page_indicator.SmoothPageIndicator(
                                    controller: _model.pageController2,
                                    count: 3,
                                    axisDirection: Axis.horizontal,
                                    onDotClicked: (i) async {
                                      await _model.pageController2
                                          .animateToPage(
                                        i,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease,
                                      );
                                    },
                                    effect: smooth_page_indicator
                                        .ExpandingDotsEffect(
                                      expansionFactor: 3,
                                      spacing: 10,
                                      radius: 10,
                                      dotWidth: 6,
                                      dotHeight: 6,
                                      dotColor: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      activeDotColor:
                                          Theme.of(context).colorScheme.primary,
                                      paintStyle: PaintingStyle.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
