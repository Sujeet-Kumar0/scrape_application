import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<User?> signInWithEmailandPassword(email, password) async {
  try {
    UserCredential credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      if (kDebugMode) {
        print('No user found for that email.');
      }
    } else if (e.code == 'wrong-password') {
      if (kDebugMode) {
        print('Wrong password provided for that user.');
      }
    }
  } catch (e) {
    print(e.toString());
  }
  return null;
}

Future<User?> signUpWithEmailandPassword(
    String emailAddress, String password) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    return credential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
  return null;
}

void logout() async {
  await auth.signOut();
}