
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String content;
  final String timestamp;
  final IconData icon;

  NotificationItem({
    required this.title,
    required this.content,
    required this.timestamp,
    required this.icon,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
 final List<NotificationItem> notifications = [
    NotificationItem(
      title: "Notificare de Alarmă",
      content: "Trebuie să pleci în 15 minute.",
      timestamp: "25 mai 2024, 08:45",
      icon: Icons.alarm,
    ),
    NotificationItem(
      title: "Mesaj nou",
      content: "Ai primit un mesaj nou de la Alice.",
      timestamp: "24 mai 2024, 17:23",
      icon: Icons.message,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(notifications[index].icon),
            title: Text(notifications[index].title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notifications[index].content),
                Text(
                  notifications[index].timestamp,
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
            onTap: () {
            },
          );
        },
      ),
    );
  }
}