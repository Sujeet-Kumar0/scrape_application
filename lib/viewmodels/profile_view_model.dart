import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/user_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  late bool isLoggedIn = false;
  late String contactSupportNumber;

  ProfileViewModel() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      isLoggedIn = user != null;
      notifyListeners();
    });

    fetchContactSupportNumber();
  }

  String getProfileGreeting(DateTime dateTime) {
    var hour = dateTime.hour;
    if (hour >= 0 && hour < 12) {
      return "Good morning,";
    } else if (hour >= 12 && hour < 17) {
      return "Good afternoon,";
    } else {
      return "Good Evening,";
    }
  }

  String getCurrentUserDisplayName() {
    return FirebaseAuth.instance.currentUser?.displayName ?? 'Guest';
  }

  void fetchContactSupportNumber() {
    // Fetch the contact support number from your API or any other source
    contactSupportNumber =
        "+91 xxxxx xxxxx"; // Replace with your logic to fetch the contact support number
  }

  UserProfile getUserProfile() {
    // Fetch the phone number and user email from your API or any other source
    String phoneNumber =
        "+91 xxxxx xxxxx"; // Replace with your logic to fetch the phone number
    String userEmail =
        'example@example.com'; // Replace with your logic to fetch the user email
    return UserProfile(phoneNumber: phoneNumber, userEmail: userEmail);
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
