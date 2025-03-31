import 'package:flutter/material.dart';

class CaregiverNotificationView extends StatelessWidget {
  const CaregiverNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[50],
                child: Icon(
                  index == 0 ? Icons.notifications : Icons.check_circle,
                  color: Colors.blue,
                ),
              ),
              title: Text(
                index == 0 ? '새로운 간병 요청이 있습니다' : '간병 요청이 수락되었습니다',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                index == 0
                    ? '서울시 강남구에서 새로운 간병 요청이 들어왔습니다.'
                    : '홍길동님의 간병 요청이 수락되었습니다.',
              ),
              trailing: Text(
                '${index + 1}시간 전',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
