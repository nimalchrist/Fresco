import 'package:flutter/material.dart';

class Notification_received extends StatefulWidget {
  const Notification_received({super.key});

  @override
  State<Notification_received> createState() => _Notification_receivedState();
}

class _Notification_receivedState extends State<Notification_received> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 223, 222, 222),
      child: const Center(child: Text("Notifications")),
    );
  }
}
