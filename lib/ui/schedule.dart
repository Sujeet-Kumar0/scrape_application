import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../components/custom_text_field.dart';
import '../model/address_model.dart';
import '../viewmodels/saved_address_viewmodel.dart';
import '../viewmodels/schedule_viewmodel.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScheduleViewModel(),
      child: ScheduleView(),
    );
  }
}

class ScheduleView extends StatefulWidget {
  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late ScheduleViewModel viewModel;

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoggedIn = false;

  @override
  void initState() {
    viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
    checkAuthState();
    super.initState();
  }

  void _showWeightOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Weight'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              children: viewModel.weightOptions
                  .map((weight) => _buildWeightButton(context, weight))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeightButton(BuildContext context, String weight) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3 - 16,
        child: ElevatedButton(
          onPressed: () {
            viewModel.updateSelectedWeight(weight);
            Navigator.pop(context); // Close the dialog
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(8.0),
          ),
          child: Text(
            weight,
            textAlign: TextAlign.center,
            // style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  Future<void> checkAuthState() async {
    // Get the current user
    // User? user = _auth.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          isLoggedIn = true;
        });
      }
    });
    // Update the isLoggedIn flag based on the authentication state
    // setState(() {
    //   isLoggedIn = user != null;
    // });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<ScheduleViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Schedule Your Pick-Up",
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Dropdown for weight selection
              ListTile(
                title: Text(
                  'Estimated Weight',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(viewModel.selectedWeight ?? 'Select weight'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                onTap: () {
                  _showWeightOptions(context);
                },
              ),
              Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              // Date selection
              ListTile(
                title: Text(
                  'Select Date',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  viewModel.selectedDate != null
                      ? '${viewModel.selectedDate?.year}-${viewModel.selectedDate?.month}-${viewModel.selectedDate?.day}'
                      : 'Select date',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                onTap: () => viewModel.selectDate(context),
              ),
              Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              // Time selection
              ListTile(
                title: Text(
                  'Select Time',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  viewModel.selectedTime != null
                      ? '${viewModel.selectedTime?.hour}:${viewModel.selectedTime?.minute}'
                      : 'Select time',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                onTap: () => viewModel.selectTime(context),
              ),
              Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              // Address selection
              ListTile(
                title: Text(
                  'Address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: viewModel.addressController.text.isNotEmpty
                    ? Text(viewModel.addressController.text)
                    : Text("Enter Your Address"),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                onTap: () => showAddressDialog(context),
              ),
              SizedBox(height: 20),
              // Button to submit the form
              ElevatedButton(
                onPressed: isLoggedIn
                    ? () => {
                          checkAuthState(),
                          if (viewModel.selectedWeight == null ||
                              viewModel.selectedDate == null ||
                              viewModel.selectedTime == null ||
                              viewModel.addressController.text.isEmpty ||
                              viewModel.pinCodeController.text.isEmpty)
                            {
                              // Display bottom sheet if any value is null
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Lottie.asset(
                                          "assets/lottie/Animation - 1709708114299.json",
                                          // width: 100,
                                          height: 100,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Please fill in all the fields.',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the bottom sheet
                                          },
                                          child: Text('Close'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            }
                          else
                            {
                              viewModel.submitForm(),
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Lottie.asset(
                                          "assets/lottie/1709494803893.json",
                                          // width: 100,
                                          height: 100,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Thank you for your request!',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Our representatives will soon reach out to you.',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the bottom sheet
                                          },
                                          child: Text('Close'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            }
                        }
                    : () => {
                          checkAuthState(),
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.errorContainer,
                              content: Text(
                                'Please Sign-In to Submit',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              duration: Duration(seconds: 3),
                            ),
                          ),
                        },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAddressDialog(BuildContext context) {
    final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);
    final addressViewModel =
        Provider.of<AddressViewModel>(context, listen: false);
    addressViewModel.loadAddresses();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Enter Your Pick-Up Details',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8),
                  CustomTextField(
                    context: context,
                    label: 'Enter Address',
                    controller: viewModel.addressController,
                    hintText: 'Enter your address',
                  ),
                  SizedBox(height: 8),
                  CustomTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      if (value.length != 6) {
                        return 'Pin Code must be exactly 6 characters long';
                      }
                      return null;
                    },
                    context: context,
                    label: 'Pin Code',
                    controller: viewModel.pinCodeController,
                    hintText: 'Enter your pin code',
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Do something with the entered address
                      // For now, just print it
                      log('Address: ${viewModel.addressController.text}\nPin Code: ${viewModel.pinCodeController.text}');
                      viewModel.notifyListeners();
                      Navigator.of(context).pop();
                    },
                    child: Text('Done'),
                  ),
                  if (addressViewModel.addresses.length != 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Divider(
                          thickness: 1,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        Text("or"),
                        Divider(
                          thickness: 1,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: addressViewModel.addresses.length,
                    itemBuilder: (context, index) {
                      final address = addressViewModel.addresses[index];
                      return ListTile(
                        title: Text(address.address),
                        subtitle: Text(address.pinCode),
                        onTap: () {
                          viewModel.addressController.text = address.address;
                          viewModel.pinCodeController.text = address.pinCode;
                        },
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final newAddress = Address(
                            viewModel.addressController.text,
                            viewModel.pinCodeController.text,
                          );
                          addressViewModel.addAddress(newAddress);
                          addressViewModel.loadAddresses();
                        },
                        child: Text('Save Your Address'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
