import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

import '../screens/notifications_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: SizedBox(
              width: 32,
              height: 32,
              child: Image.asset(
                'assets/images/notification.webp',
                fit: BoxFit.contain,
              ),
            ),
            title: const Text('Notification'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: SizedBox(
              width: 32,
              height: 32,
              child: Icon(Icons.share)
            ),
            title: Text('Share this app'),
          ),
          ListTile(
            leading: SizedBox(
              width: 32,
              height: 32,
              child: Image.asset(
                'assets/images/contact_us.png',
                fit: BoxFit.contain,
              ),
            ),
            title: const Text('Contact Us'),
          ),
          ListTile(
            leading: SizedBox(
              width: 32,
              height: 32,
              child: Image.asset(
                'assets/images/rate_app.png',
                fit: BoxFit.contain,
              ),
            ),
            title: const Text('Rate this app'),
          ),
          ListTile(
            leading: SizedBox(
                width: 32,
                height: 32,
                child: Image.asset(
                  'assets/images/info.png',
                  fit: BoxFit.contain,
                ),
            ),
            title: Text('About Us'),
          ),
          ListTile(
            leading: SizedBox(
              width: 32,
              height: 32,
              child: Icon(Icons.exit_to_app),
            ),
            title: Text("Exit App"),
            onTap: () async {
              final shouldExit = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Thoát app?"),
                    content: Text("Bạn có chắc muốn thoát ứng dụng không?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Không"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("Thoát"),
                      ),
                    ],
                  );
                },
              );

              if (shouldExit == true) {
                SystemNavigator.pop();
              }
            }
          ),
        ],
      ),
    );
  }
}
