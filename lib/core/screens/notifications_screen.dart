import 'package:flutter/material.dart';

import '../../services/notifications_repository.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            );
          },
        ),
      ),
      body: ValueListenableBuilder<List<NotificationItem>>(
        valueListenable: NotificationsRepository.notifications,
        builder: (context, list, _) {
          if (list.isEmpty) {
            return Center(
              child: Text(
                'Không có thông báo nào',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = list[index];

              return GestureDetector(
                onTap: () {
                  NotificationsRepository.markAsRead(index);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (item.isRead ?? false)
                        ? Colors.white
                        : Colors.teal.withOpacity(0.12), // chưa đọc → highlight
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.notifications, color: Colors.teal),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: (item.isRead ?? false)
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(item.body),
                            const SizedBox(height: 6),
                            Text(
                              item.time,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          NotificationsRepository.removeAt(index);
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }
}
