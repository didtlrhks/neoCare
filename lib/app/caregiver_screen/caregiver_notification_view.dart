import 'package:flutter/material.dart';

class CaregiverNotificationView extends StatelessWidget {
  const CaregiverNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '알림',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('알림 페이지'),
      ),
    );
  }
}
