import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CareRequestView extends StatelessWidget {
  const CareRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            const Text('간병요청', style: TextStyle(fontWeight: FontWeight.w500)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '어떤 간병이 필요한가요?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // 단순간병 옵션
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCareOption(
              title: '단순간병',
              isSelected: false,
              onTap: () {
                Get.snackbar('알림', '단순간병을 선택하셨습니다');
              },
            ),
          ),
          const SizedBox(height: 20),
          // 전문간병 옵션
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCareOption(
              title: '전문간병\n(자격증 소지자)',
              isSelected: false,
              onTap: () {
                Get.snackbar('알림', '전문간병을 선택하셨습니다');
              },
            ),
          ),
          const Spacer(),
          // 다음 버튼
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar('알림', '다음 단계로 이동합니다');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  '다음',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                'assets/images/carrot.png',
                errorBuilder: (context, error, stackTrace) {
                  print("이미지 로드 오류: $error");
                  return Icon(
                    Icons.eco,
                    size: 40,
                    color: Colors.orange.shade200,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
