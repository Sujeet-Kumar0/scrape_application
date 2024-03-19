import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Spacer(flex: 2),
          // Expanded(child: SearchField()),
          ProfileCard()
        ],
      ),
    );
  }
}


class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    var profileName = user != null ? user.displayName ?? "User" : "User";

    return Container(
      margin: const EdgeInsets.only(left: 16),
      child: PopupMenuButton<String>(
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'profile',
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    profileName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout),
                SizedBox(width: 8),
                Text('Logout'),
              ],
            ),
          ),
        ],
        onSelected: (String value) async {
          if (value == 'logout') {
            await FirebaseAuth.instance.signOut();
            // Redirect to login page or any other necessary actions
          }
        },
        icon: Icon(Icons.keyboard_arrow_down),
      ),
    );
  }
}

