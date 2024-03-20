import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrape_application/utils/pickup_status.dart';

import '../model/address_model.dart';
import '../model/order_detail_model.dart';

class ScheduleViewModel extends ChangeNotifier {
  late String? selectedWeight;
  late DateTime? selectedDate;
  late TimeOfDay? selectedTime;
  final List<String> weightOptions = [
    '<20kg',
    '20-50kg',
    '50-100kg',
    '100-700kg',
    "700Kg+"
  ];
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  ScheduleViewModel() {
    selectedWeight = null;
    selectedDate = null;
    selectedTime = null;
  }

  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  void updateSelectedWeight(String? newValue) {
    selectedWeight = newValue!;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      notifyListeners();
    }
  }

  Future<void> submitForm() async {
    // Implement your form submission logic here
    print('Submitting form...');
    CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('Orders');

    var orderDetails = OrderDetails(selectedWeight!, selectedDate!,
        selectedTime!, Address(addressController.text, pinCodeController.text),
        status: Status.upcoming, userId: userId!);

    // Create a map representing the order details
    // Map<String, dynamic> orderData = {
    //   'selectedWeight': selectedWeight!,
    //   'selectedDateAndTime': DateTime(selectedDate!.year, selectedDate!.month,
    //       selectedDate!.day, selectedTime!.hour, selectedTime!.minute),
    //   // 'selectedTime': selectedTime,
    //   'address': {
    //     'address': addressController.text,
    //     'pinCode': pinCodeController.text,
    //   },
    //   'status': Status.upcoming.name
    // };
    try {
      // Add the order details to Firestore
      await ordersCollection.add(orderDetails.toMap());

      // Print a success message
      log('Order details added to Firestore successfully!');
    } catch (e) {
      // Print an error message if something goes wrong
      log('Error adding order details to Firestore: $e');
    }
    log('Selected Weight: ${orderDetails.selectedWeight}');
    log('Selected Date: ${orderDetails.selectedDate}');
    log('Selected Time: ${orderDetails.selectedTime}');
    log('Address: ${orderDetails.address.address}');
    log('Pin Code: ${orderDetails.address.pinCode}');

    // Reset all values
    selectedWeight = null;
    selectedDate = null;
    selectedTime = null;
    addressController.clear();
    pinCodeController.clear();
    notifyListeners();
  }

  void dispose() {
    addressController.dispose();
    super.dispose();
  }
}
