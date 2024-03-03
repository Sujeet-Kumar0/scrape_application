import 'package:flutter/material.dart';

class ScheduleViewModel extends ChangeNotifier {
  late String? selectedWeight;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  final List<String> weightOptions = ['<20kg', '20-50kg', '50-100kg', '100-700kg',"700Kg+"];
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  ScheduleViewModel() {
    selectedWeight = weightOptions.isNotEmpty ? weightOptions[0] : null;
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

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
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      notifyListeners();
    }
  }

  void submitForm() {
    // Implement your form submission logic here
    print('Submitting form...');
    var orderDetails = OrderDetails(selectedWeight!,selectedDate,selectedTime,Address(addressController.text ,pinCodeController.text));
    print('Selected Weight: ${orderDetails.selectedWeight}');
    print('Selected Date: ${orderDetails.selectedDate}');
    print('Selected Time: ${orderDetails.selectedTime}');
    print('Address: ${orderDetails.address.address}');
    print('Pin Code: ${orderDetails.address.pinCode}');
  }

  void dispose() {
    addressController.dispose();
    super.dispose();
  }
}



class OrderDetails {
  String selectedWeight;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  Address address;

  OrderDetails(this.selectedWeight, this.selectedDate, this.selectedTime, this.address);
}

class Address {
  String address;
  String pinCode;

  Address(this.address, this.pinCode);
}

