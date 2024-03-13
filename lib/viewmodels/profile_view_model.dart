import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/user_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  late bool isLoggedIn = false;
  late String contactSupportNumber;
  var firebaseAuth = FirebaseAuth.instance;
  var db = FirebaseFirestore.instance;
  String? userId;

  ProfileViewModel() {
    firebaseAuth.authStateChanges().listen((User? user) {
      isLoggedIn = user != null;
      if (user != null) {
        userId = user.uid;
      }
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
    if (isLoggedIn) {
      return firebaseAuth.currentUser?.displayName ?? 'Guest';
    } else {
      return 'Guest';
    }
  }

  void fetchContactSupportNumber() {
    // FirebaseDatabase database = FirebaseDatabase.instance;
    // final ref = FirebaseDatabase.instance.ref();
    // final snapshot = await ref.child('contactSupportNumber').get();
    // if (snapshot.exists) {
    //     print(snapshot.value);
    // } else {
    //     print('No data available.');
    // }

    contactSupportNumber = "+91 xxxxx xxxxx";
  }

  Future<UserProfile> getUserProfile() async {
    var phoneNumber = "+91 xxxxx xxxxx";
    var userEmail = 'example@example.com';
    var userName = 'Guest';

    if (userId != null) {
      final docRef = db.collection("users").doc(userId);
      try {
        final doc = await docRef.get();
        final data = doc.data() as Map<String, dynamic>;
        phoneNumber = data['phoneNumber'];
        userEmail = data['email'];
        userName = data['userName'];
      } catch (e) {
        print("Error getting document: $e");
        // Handle the error gracefully, e.g., set default values or throw an exception
      }
    }

    return UserProfile(
      phoneNumber: phoneNumber,
      userEmail: userEmail,
      profileName: userName,
      userId: userId,
    );
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
