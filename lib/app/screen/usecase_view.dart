import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_view.dart';

class UseCaseView extends StatelessWidget {
  const UseCaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('서비스 이용 안내'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              '네오케어 서비스 이용방법',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildUseCaseItem(
              icon: Icons.app_registration,
              title: '1. 회원가입하기',
              description: '간단한 정보로 빠르게 회원가입을 진행합니다.',
            ),
            _buildUseCaseItem(
              icon: Icons.search,
              title: '2. 간병인 찾기',
              description: '환자 상태에 맞는 최적의 간병인을 찾아보세요.',
            ),
            _buildUseCaseItem(
              icon: Icons.calendar_month,
              title: '3. 일정 예약하기',
              description: '필요한 날짜와 시간에 간병 서비스를 예약합니다.',
            ),
            _buildUseCaseItem(
              icon: Icons.payments,
              title: '4. 간편 결제하기',
              description: '다양한 방법으로 안전하게 결제할 수 있습니다.',
            ),
            _buildUseCaseItem(
              icon: Icons.star,
              title: '5. 서비스 평가하기',
              description: '서비스가 완료된 후 만족도를 평가해주세요.',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.to(() => const AuthView()),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('서비스 시작하기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUseCaseItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.orange,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
