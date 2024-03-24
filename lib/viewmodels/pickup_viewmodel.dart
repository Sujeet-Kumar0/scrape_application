import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class PickupViewModel extends ChangeNotifier {
  late TabController tabController;
  final unfocusNode = FocusNode();
  // List<OrderDetails> orders = [];
  // List<OrderDetails> upcomingOrders = [];
  // List<OrderDetails> completedOrders = [];

  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  void init(TickerProvider vsync) {
    tabController = TabController(length: 2, initialIndex: 0, vsync: vsync);
    // fetchOrders();
  }

  void dispose() {
    tabController.dispose();
    unfocusNode.dispose();
  }

  // Future<void> fetchOrders() async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('Orders')
  //         .doc(userId)
  //         .collection("order")
  //         .get();
  //     orders = snapshot.docs.map((doc) {
  //       final data = doc.data();
  //       return OrderDetails(
  //         data['selectedWeight'] ?? "",
  //         (data['selectedDateAndTime'] as Timestamp).toDate(),
  //         TimeOfDay.fromDateTime(
  //             (data['selectedDateAndTime'] as Timestamp).toDate()),
  //         Address.fromJson(data['address']),
  //       );

  //       // // Print the order details(debug purpose)
  //       // print('Selected Weight: ${orderDetails.selectedWeight}');
  //       // print('Selected Date: ${orderDetails.selectedDate}');
  //       // print('Selected Time: ${orderDetails.selectedTime}');
  //       // print('Address: ${orderDetails.address.address}');
  //       // print('Pin Code: ${orderDetails.address.pinCode}');

  //       // return orderDetails;
  //     }).toList();
  //   } catch (e) {
  //     print('Error fetching orders: $e');
  //   }
  // }

  Stream<QuerySnapshot> fetchOrdersStream() {
    return FirebaseFirestore.instance
        .collection('Orders')
        // .doc(userId)
        // .collection("order")
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}
