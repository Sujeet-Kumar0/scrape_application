import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/user_profile.dart';

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
    return AlertDialog(
      title: Text('Edit Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextFormField(
            controller: _phoneNumberController,
            decoration: InputDecoration(labelText: 'Phone Number'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
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
              // Add the order details to Firestore
              await usersCollection.doc(updatedProfile.userId).update({
                'phoneNumber': newPhoneNumber,
                'userName': newName,
                'email': widget.userProfile.userEmail,
              });
              // Print a success message
              print('Updated User details added to Firestore successfully!');
            } catch (e) {
              // Print an error message if something goes wrong
              print('Error adding order details to Firestore: $e');
            }
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
