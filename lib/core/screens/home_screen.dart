import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resume_builder_project/core/screens/add_resume_builder_screen.dart';
import 'package:resume_builder_project/core/utils/app_utils.dart';
import '../../services/notifications_repository.dart';
import '../widgets/app_drawer.dart';
import '../widgets/resume_list_view.dart';
import 'download_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final ok = await AppUtils.confirmExit(context);
        if (ok) SystemNavigator.pop();
        return false;
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
            ValueListenableBuilder(
              valueListenable: NotificationsRepository.notifications,
              builder: (context, list, _) {
                final unread =
                    list.where((x) => !(x.isRead ?? false)).length;

                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications,
                          color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
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
                          child: Text(
                            unread > 9 ? "9+" : unread.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
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

        // 👉 CV LIST
        body: const ResumeListView(),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddResumeBuilderScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
