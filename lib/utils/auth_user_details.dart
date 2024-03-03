import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthUserStreamWidget extends StatelessWidget {
  final Widget Function(BuildContext context, String? currentUserDisplayName)
      builder;

  const AuthUserStreamWidget({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final currentUserDisplayName = snapshot.data?.displayName;
        return builder(context, currentUserDisplayName);
      },
    );
  }
}
