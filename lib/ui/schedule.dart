import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                  .map((weight) => _buildWeightButton(weight))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeightButton(String weight) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          viewModel.updateSelectedWeight(weight);
          Navigator.pop(context); // Close the dialog
        },
        child: Text(weight),
      ),
    );
  }

  Future<void> checkAuthState() async {
    // Get the current user
    User? user = _auth.currentUser;

    // Update the isLoggedIn flag based on the authentication state
    setState(() {
      isLoggedIn = user != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<ScheduleViewModel>(context);

    return Scaffold(
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
                // subtitle: viewModel.addressController.text.isEmpty
                //     ? Text(viewModel.addressController.text)
                //     : null,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    : () => {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor:
                                Theme.of(context).colorScheme.errorContainer,
                            content: Text(
                              'Please Sign-In to Submit',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            duration: Duration(seconds: 3),
                          ))
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Your Pick-Up Details',
              style: Theme.of(context).textTheme.headlineMedium),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  // maxLines: 3,
                  controller: viewModel.addressController,
                  decoration: InputDecoration(
                    label: Text('Enter Address'),
                    // labelText: "Please Enter Your Full Address",
                    fillColor: const Color(0xfff6f6f6),
                    filled: true,
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    alignLabelWithHint: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.transparent
                            //Color(0xff29b973),
                            )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff29b973),
                        )),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: viewModel.pinCodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    label: Text('Pin Code'),
                    // labelText: "Please Enter Your PIN Code",
                    fillColor: const Color(0xfff6f6f6),
                    filled: true,
                    labelStyle: TextStyle(color: Colors.grey[500]),
                    // alignLabelWithHint: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.transparent
                            //Color(0xff29b973),
                            )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff29b973),
                        )),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 8),
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
                InkWell(
                  child: Material(
                    color: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3,
                            color: Color(0x33000000),
                            offset: Offset(0, 1),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(0xFFFFFFFF),
                          width: 0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.edit_location,
                                // color: FlutterFlowTheme.of(context).secondaryText,
                                size: 24,
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Text(
                                'Saved Address',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Do something with the entered address
                // For now, just print it
                print('Address: ${viewModel.addressController.text}');
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
