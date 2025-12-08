import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resume_builder_project/core/screens/add_resume_builder_screen.dart';
import '../../services/notifications_repository.dart';
import '../widgets/app_drawer.dart';
import 'download_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Hàm confirm thoát
  Future<bool> _confirmExit() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thoát app?"),
          content: const Text("Bạn có chắc muốn thoát ứng dụng không?"),
          actions: [
            TextButton(
              child: const Text("Không"),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text("Thoát"),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool ok = await _confirmExit();
        if (ok) SystemNavigator.pop();
        return false; // chặn back mặc định
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Resume Builder',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          backgroundColor: Colors.teal,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.download, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DownloadScreen()),
                );
              },
            ),

            // badge notification
            ValueListenableBuilder<List<NotificationItem>>(
              valueListenable: NotificationsRepository.notifications,
              builder: (context, list, _) {
                final int unread =
                    list.where((x) => !(x.isRead ?? false)).length;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NotificationScreen()),
                        );
                      },
                    ),
                    if (unread > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Center(
                            child: Text(
                              unread > 9 ? '9+' : unread.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),

        drawer: const AppDrawer(),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AddResumeBuilderScreen()),
            );
          },
          shape: const CircleBorder(),
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
