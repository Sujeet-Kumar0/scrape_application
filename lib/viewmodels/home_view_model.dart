// viewmodels/home_view_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdBanner {
  String imageUrl;

  AdBanner({required this.imageUrl});
}

class HomeViewModel extends ChangeNotifier {
  final unfocusNode = FocusNode();

  late PageController pageController1;

  int _pageIndex1 = 0;

  int get pageIndex1 => _pageIndex1;

  int scrap = 00000000;

  bool get canUnfocus => unfocusNode.canRequestFocus;

  late List<AdBanner> adBanners; // List to hold ad banners
  bool isLoading = false;

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
    adBanners = [
      AdBanner(imageUrl: 'https://picsum.photos/seed/676/600'),
      AdBanner(imageUrl: 'https://picsum.photos/seed/645/600'),
      AdBanner(imageUrl: 'https://picsum.photos/seed/143/600'),
    ];

    trackScrapSold();
  }

  // Function to load more ad banners
  Future<void> loadMoreAdBanners() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();

      // Load more ad banners (Example: Load 3 more)
      adBanners.addAll([
        AdBanner(imageUrl: 'https://picsum.photos/seed/111/600'),
        AdBanner(imageUrl: 'https://picsum.photos/seed/222/600'),
        AdBanner(imageUrl: 'https://picsum.photos/seed/333/600'),
      ]);

      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    pageController1.dispose();
    super.dispose();
  }
}
