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

  void addItemToDB(ItemData newItem) {
    firestore.collection('rates').add({
      'itemName': newItem.itemName,
      'price': newItem.price,
      'imageURL': newItem.imageURL,
    }).then((_) {
      print('Item added successfully');
      readDataFromDB(); // Refresh data after adding
    }).catchError((error) {
      print('Failed to add item: $error');
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

  void updateItemInDB(ItemData updatedItem, String itemId) {
    firestore.collection('rates').doc(itemId).update({
      'itemName': updatedItem.itemName,
      'price': updatedItem.price,
      'imageURL': updatedItem.imageURL,
    }).then((_) {
      print('Item updated successfully');
      readDataFromDB(); // Refresh data after updating
    }).catchError((error) {
      print('Failed to update item: $error');
    });
  }

  void deleteItemFromDB(String itemId) {
    firestore.collection('rates').doc(itemId).delete().then((_) {
      print('Item deleted successfully');
      readDataFromDB(); // Refresh data after deletion
    }).catchError((error) {
      print('Failed to delete item: $error');
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
