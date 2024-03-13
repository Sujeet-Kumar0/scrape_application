import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/address_model.dart';
import '../viewmodels/saved_address_viewmodel.dart';

class SavedAddressDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SavedAddressDialog._buildDialog(context);
      },
    );
  }

  static Widget _buildDialog(BuildContext context) {
    final viewModel = Provider.of<AddressViewModel>(context, listen: true);

    return Dialog.fullscreen(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your Saved Addresses',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: viewModel.addresses.length,
                itemBuilder: (context, index) {
                  final address = viewModel.addresses[index];
                  return ListTile(
                    title: Text(address.address),
                    subtitle: Text(address.pinCode),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        viewModel.deleteAddress(address);
                      },
                    ),
                    onTap: () {
                      const snackBar =
                          SnackBar(content: Text("Button Pressed"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      SavedAddressDialog._showEditAddressDialog(
                          context, address);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Add a new address
                _showEditAddressDialog(context, null);
              },
              child: Text('Add New Address'),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  static void _showEditAddressDialog(BuildContext context, Address? address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SavedAddressDialog._buildEditAddressDialog(context, address);
      },
    );
  }

  static Widget _buildEditAddressDialog(
      BuildContext context, Address? address) {
    final viewModel = Provider.of<AddressViewModel>(context, listen: true);

    TextEditingController addressController = TextEditingController();
    TextEditingController pinCodeController = TextEditingController();

    if (address != null) {
      addressController.text = address.address;
      pinCodeController.text = address.pinCode;
    }

    return Dialog(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              address != null ? 'Edit Address' : 'Add Address',
              textAlign: TextAlign.center,
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: pinCodeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(labelText: 'Pin Code'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final newAddress = Address(
                      addressController.text,
                      pinCodeController.text,
                    );
                    if (address != null) {
                      viewModel.updateAddress(address, newAddress);
                    } else {
                      viewModel.addAddress(newAddress);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(address != null ? 'Save Changes' : 'Add Address'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
