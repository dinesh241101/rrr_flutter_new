import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0F4C81)),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Run Reward Rift',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Reward History'),
          ),
          ListTile(
            leading: Icon(Icons.notifications_active_outlined),
            title: Text('Notifications'),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
          ),
        ],
      ),
    );
  }
}
