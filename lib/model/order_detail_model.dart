import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrape_application/utils/pickup_status.dart';

import 'address_model.dart';

class OrderDetails {
  String selectedWeight;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  Address address;
  Status? status = Status.upcoming;
  String? userId;

  OrderDetails(
      this.selectedWeight, this.selectedDate, this.selectedTime, this.address,
      {this.status, this.userId});

  Map<String, dynamic> toMap() {
    return {
      'selectedWeight': selectedWeight,
      'selectedDateAndTime': DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour, selectedTime.minute),
      // 'selectedDate': selectedDate,
      // 'selectedTime': selectedTime,
      'address': address.toJson(),
      'status': status!.name,
      'userId': userId
    };
  }

  factory OrderDetails.fromFirestore(Map<String, dynamic> data) {
    final selectedWeight = data['selectedWeight'] ?? "";
    final selectedDateTime =
        (data['selectedDateAndTime'] as Timestamp?)?.toDate();
    final selectedDateAndTime = selectedDateTime != null
        ? TimeOfDay.fromDateTime(selectedDateTime)
        : null;
    final addressJson = data['address'];
    final address = addressJson != null ? Address.fromJson(addressJson) : null;
    final status = (data["status"] as String).toLowerCase() == 'completed'
        ? Status.completed
        : Status.upcoming;
    final userId = data['userId'];

    if (selectedDateAndTime == null || address == null) {
      throw Exception(
          'Invalid data'); // Handle the case when necessary data is null
    }

    return OrderDetails(
        selectedWeight, selectedDateTime!, selectedDateAndTime, address,
        status: status, userId: userId);
  }
}
