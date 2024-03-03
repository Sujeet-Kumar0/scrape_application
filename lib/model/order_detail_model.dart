import 'package:flutter/material.dart';

import 'address_model.dart';

class OrderDetails {
  String selectedWeight;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  Address address;

  OrderDetails(
      this.selectedWeight, this.selectedDate, this.selectedTime, this.address);
}
