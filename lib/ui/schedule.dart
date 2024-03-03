import 'package:flutter/material.dart';
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

class ScheduleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleViewModel>(context);

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
                subtitle: null,
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                // onChanged: viewModel.updateSelectedWeight,
                // items: viewModel.weightOptions.map((String value) {
                //   return DropdownMenuItem<String>(
                //     value: value,
                //     child: Text(value),
                //   );
                // }).toList(),
                // decoration: InputDecoration(
                //   labelText: ,
                //   border: InputBorder.none,
                //   contentPadding:
                //       EdgeInsets.symmetric(horizontal: 12, vertical: 8),

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
                  '${viewModel.selectedDate.year}-${viewModel.selectedDate.month}-${viewModel.selectedDate.day}',
                  style: Theme.of(context).textTheme.titleMedium,
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
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                  '${viewModel.selectedTime.hour}:${viewModel.selectedTime.minute}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                trailing: Icon(
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
                  style: Theme.of(context).textTheme.headline6,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                onTap: () => _showAddressDialog(context),
              ),
              SizedBox(height: 20),
              // Button to submit the form
              ElevatedButton(
                onPressed: viewModel.submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddressDialog(BuildContext context) {
    final viewModel = Provider.of<ScheduleViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Address'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: viewModel.addressController,
                  decoration: InputDecoration(
                    labelText: 'Full Address',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Pin Code',
                  ),
                ),
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
