import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 5,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/Scrap.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: Icons.home,
            press: () {
              context.go("/dashboard");
            },
          ),
          DrawerListTile(
            title: "Update Rates",
            icon: Icons.book_outlined,
            press: () {
              context.go("/rates_updater");
            },
          ),
          DrawerListTile(
            title: "Orders",
            icon: Icons.done_all_outlined,
            press: () {
              context.go("/orders");
            },
          ),
          DrawerListTile(
            title: "Users Details",
            icon: Icons.person_2,
            press: () {
              context.go("/user-details");
            },
          )
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      title: Text(
        title,
        // style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
