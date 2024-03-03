import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/item_data.dart';

class RatesScreenViewModel extends ChangeNotifier {
  List<ItemData> items = [];
  List<ItemData> filteredItems = [];
  final firestore = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();

  String empty = 'Nothing Here!';

  RatesScreenViewModel() {
    readDataFromDB();
  }

  void readDataFromDB() {
    firestore.collection('rates').get().then((querySnapshot) {
      print("Successfully fetched");
      items = querySnapshot.docs
          .map((doc) => ItemData(
                itemName: doc['itemName'],
                price: doc['price'],
                imageURL: doc['imageURL'],
              ))
          .toList();
      filteredItems = List.from(items);

      notifyListeners();
    }).catchError((error) {
      print("Error fetching data: $error");
      empty = "Error from Our Internals";
      notifyListeners();
    });
  }

  void performSearch(String searchText) {
    searchText = searchText.trim().toLowerCase();
    filteredItems = items
        .where((item) => item.itemName.toLowerCase().contains(searchText))
        .toList();
    if (filteredItems.isEmpty) {
      empty = "Nothing Found!";
    }
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
