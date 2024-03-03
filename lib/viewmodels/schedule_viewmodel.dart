import 'package:flutter/material.dart';

class ScheduleViewModel extends ChangeNotifier {
  late String selectedWeight;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  final List<String> weightOptions = ['<20kg', '20-50kg', '50-100kg', '100kg+'];
  final TextEditingController addressController = TextEditingController();

  ScheduleViewModel() {
    selectedWeight = weightOptions[0];
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
  }

  void dispose() {
    addressController.dispose();
    super.dispose();
  }
}
