import 'package:flutter/material.dart';

enum NotificationChannel {
  appPush('앱 푸시', '앱에서 실시간으로 받아보세요', Icons.notifications_outlined),
  email('이메일', '이메일로 받아보세요', Icons.mail_outlined),
  sms('SMS', '문자로 받아보세요', Icons.chat_bubble_outline);

  const NotificationChannel(this.label, this.description, this.icon);

  final String label;
  final String description;
  final IconData icon;
}
