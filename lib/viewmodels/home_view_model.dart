// viewmodels/home_view_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/adbanner_model.dart';

class HomeViewModel extends ChangeNotifier {
  final unfocusNode = FocusNode();

  late PageController pageController1;

  int _pageIndex1 = 0;

  int get pageIndex1 => _pageIndex1;

  int scrap = 00000000;

  bool get canUnfocus => unfocusNode.canRequestFocus;

  late List<AdBanner> adBanners; // List to hold ad banners

  void onPageChanged1(int index) {
    _pageIndex1 = index;
    notifyListeners();
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
      scrap = soldAmount;
      notifyListeners();
    });
  }

  HomeViewModel() {
    // Initialize adBanners
    adBanners = [];

    trackScrapSold();
    fetchAdBannerUrls();
  }

  // Function to fetch ad banner URLs from Firebase Cloud Storage
  void fetchAdBannerUrls() {
    FirebaseFirestore.instance
        .collection('scrap')
        .doc('banners')
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('urls')) {
          // Convert the list of URLs to a list of AdBanner objects
          List<String> urls = List<String>.from(data['urls']);
          adBanners = urls.map((url) => AdBanner(imageUrl: url)).toList();
          notifyListeners();
        }
      }
    }).catchError((error) {
      print('Error fetching ad banner URLs: $error');
    });
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    pageController1.dispose();
    super.dispose();
  }
}
