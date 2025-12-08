import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String body;
  final String time;
  // cho phép nullable để không crash nếu có instance cũ chứa null
  bool? isRead;

  NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false, // default: chưa đọc
  });
}

class NotificationsRepository {
  // Mock initial notifications
  static final ValueNotifier<List<NotificationItem>> notifications =
  ValueNotifier<List<NotificationItem>>([
    NotificationItem(
      title: 'New message',
      body: 'Bạn có tin nhắn mới từ HR.',
      time: '2 phút trước',
      isRead: false,
    ),
    NotificationItem(
      title: 'System update',
      body: 'Ứng dụng vừa cập nhật phiên bản 1.2.0.',
      time: '10 phút trước',
      isRead: false,
    ),
    NotificationItem(
      title: 'Reminder',
      body: 'Đừng quên cập nhật CV hôm nay.',
      time: '1 giờ trước',
      isRead: false,
    ),
  ]);

  // Tổng số thông báo
  static int get count => notifications.value.length;

  // Thêm notification (bảo đảm isRead không null)
  static void add(NotificationItem item) {
    final safeItem = NotificationItem(
      title: item.title,
      body: item.body,
      time: item.time,
      isRead: item.isRead ?? false,
    );
    notifications.value = [...notifications.value, safeItem];
  }

  // Xóa theo index (an toàn)
  static void removeAt(int index) {
    if (index < 0 || index >= notifications.value.length) return;
    final copy = [...notifications.value];
    copy.removeAt(index);
    notifications.value = copy;
  }

  static void clear() {
    notifications.value = [];
  }

  // Đánh dấu đã đọc (an toàn)
  static void markAsRead(int index) {
    if (index < 0 || index >= notifications.value.length) return;
    final updated = [...notifications.value];
    updated[index].isRead = true;
    notifications.value = updated;
  }

  // Đếm số chưa đọc — null hoặc false đều tính là chưa đọc
  static int get unreadCount =>
      notifications.value.where((x) => (x.isRead ?? false) == false).length;

  // Đánh dấu tất cả là đã đọc (optional)
  static void markAllAsRead() {
    final updated = notifications.value.map((n) {
      return NotificationItem(
        title: n.title,
        body: n.body,
        time: n.time,
        isRead: true,
      );
    }).toList();
    notifications.value = updated;
  }
}
