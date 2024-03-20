import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:scrape_application/components/headers.dart';
import 'package:scrape_application/components/side_bar.dart';

import '../../components/custom_text_field.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  IconData editIcon = Icons.edit;
  bool isEditing = false;
  TextEditingController scrapController = TextEditingController();
  int scrap = 0;
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _urlController = TextEditingController();
  List<String> _adBanners = [];

  @override
  void initState() {
    super.initState();
    checkAuthentication();
    trackScrapSold();
    _controller = AnimationController(vsync: this);
    scrapController.text = scrap.toString();
    _getAdBanners();
  }

  @override
  void dispose() {
    _controller.dispose();
    scrapController.dispose();
    super.dispose();
  }

// Function to track scrap sold
  void trackScrapSold() {
    FirebaseFirestore.instance
        .collection('scrap')
        .doc('sold')
        .snapshots()
        .listen((snapshot) {
      final soldAmount = snapshot.data()!['soldAmount'];
      print('Scrap sold: $soldAmount');
      setState(() {
        scrap = soldAmount;
      });
      // You can perform any actions you want with the scrap sold data here
    });
  }

  void updateScrap() {
    setState(() {
      scrap = int.tryParse(scrapController.text) ?? 0;
      updateScrapSold(scrap);
      isEditing = false;
      editIcon = Icons.edit;
      trackScrapSold();
    });
  }

// Function to track scrap sold
  Future<void> updateScrapSold(int scrap) async {
    try {
      await FirebaseFirestore.instance.collection('scrap').doc('sold').update({
        'soldAmount': scrap,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('Scrap sold updated successfully!');
    } catch (e) {
      print('Error updating scrap sold: $e');
    }
  }

  // Function to check authentication status
  void checkAuthentication() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        // Navigate to login page if user is not authenticated
        context.go("/login");
      }
    });
  }

  void _getAdBanners() async {
    List<String> banners = await _firebaseService.getAdBanners();
    setState(() {
      _adBanners = banners;
    });
  }

  void _addAdBanner() async {
    String imageUrl = _urlController.text.trim();
    if (imageUrl.isNotEmpty) {
      await _firebaseService.createAdBanner(imageUrl);
      _urlController.clear();
      _getAdBanners();
    }
  }

  void _deleteAdBanner(String imageUrl) async {
    await _firebaseService.deleteAdBanner(imageUrl);
    _getAdBanners();
  }

  @override
  Widget build(BuildContext context) {
    return buildDashBoard(context);
  }

  Widget buildDashBoard(BuildContext context) {
    return Scaffold(
      // appBar: const Header(),
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (kIsWeb)
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            // Dashboard
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      //Heading
                      // need to pass the User Credentials
                      Header(),
                      const SizedBox(height: 24),
                      // Scrap Sold update
                      Stack(
                        children: [
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
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: '$scrap Has been sold',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.white))
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEditing = !isEditing;
                                  editIcon =
                                      isEditing ? Icons.check : Icons.edit;
                                  if (!isEditing) {
                                    updateScrap();
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  editIcon,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          if (isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                color: Colors.black.withOpacity(0.5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: scrapController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter new value',
                                          hintStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: updateScrap,
                                      icon: const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Your Banners Control:",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  context: context,
                                  label: 'Image URL',
                                  controller: _urlController,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: _addAdBanner,
                                  child: Text('Add Ad Banner'),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 250,
                              child: ListView.builder(
                                itemCount: _adBanners.length,
                                itemBuilder: (context, index) {
                                  String imageUrl = _adBanners[index];
                                  return ListTile(
                                    title: Text(imageUrl),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () =>
                                          _deleteAdBanner(imageUrl),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      // const Text("New Orders"),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   "some Orders Numbers",
                      //   style: Theme.of(context).textTheme.titleLarge,
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // const Text("New Users"),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   "some Numbers Users",
                      //   style: Theme.of(context).textTheme.titleLarge,
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FirebaseService {
  final _firestore =
      FirebaseFirestore.instance.collection('scrap').doc('banners');

  Future<void> createAdBanner(String imageUrl) async {
    try {
      await _firestore.update({
        'urls': FieldValue.arrayUnion([imageUrl]),
      });
    } catch (e) {
      print('Error creating ad banner: $e');
    }
  }

  Future<List<String>> getAdBanners() async {
    try {
      var docSnapshot = await _firestore.get();
      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        return List<String>.from(data['urls']);
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting ad banners: $e');
      return [];
    }
  }

  Future<void> deleteAdBanner(String imageUrl) async {
    try {
      await _firestore.update({
        'urls': FieldValue.arrayRemove([imageUrl]),
      });
    } catch (e) {
      print('Error deleting ad banner: $e');
    }
  }
}
