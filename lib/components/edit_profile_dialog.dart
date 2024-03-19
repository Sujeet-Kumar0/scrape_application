import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/user_profile.dart';
import 'custom_text_field.dart';

class EditProfileDialog extends StatefulWidget {
  final UserProfile userProfile;

  EditProfileDialog({required this.userProfile});

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.userProfile.profileName);
    _phoneNumberController =
        TextEditingController(text: widget.userProfile.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text('Edit Profile',
                    style: Theme.of(context).textTheme.titleLarge)),
            SizedBox(height: 20.0),
            CustomTextField(
              context: context,
              label: 'Name',
              controller: _nameController,
            ),
            SizedBox(height: 10.0),
            CustomTextField(
              context: context,
              label: 'Phone Number',
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    // Save changes here
                    String newName = _nameController.text;
                    String newPhoneNumber = _phoneNumberController.text;
                    // Update user profile with new details
                    UserProfile updatedProfile = UserProfile(
                      profileName: newName,
                      phoneNumber: newPhoneNumber,
                      userEmail: widget.userProfile.userEmail,
                      userId: widget.userProfile.userId,
                    );
                    CollectionReference usersCollection =
                        FirebaseFirestore.instance.collection('users');
                    try {
                      // Update the user details in Firestore
                      await usersCollection.doc(updatedProfile.userId).update({
                        'phoneNumber': newPhoneNumber,
                        'userName': newName,
                        'email': widget.userProfile.userEmail,
                      });
                      // Print a success message
                      print(
                          'Updated User details added to Firestore successfully!');
                    } catch (e) {
                      // Print an error message if something goes wrong
                      print('Error updating user details in Firestore: $e');
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
