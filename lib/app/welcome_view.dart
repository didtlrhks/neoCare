import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'guardian_screen/guardian_home_view.dart';
import 'caregiver_screen/caregiver_home_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                '케어플러스에\n오신것을 환영합니다!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _buildOptionCard(
                title: '간병인을\n요청하고 싶다면',
                buttonText: '보호자',
                buttonTextColor: Colors.indigo.shade700,
                iconColor: Colors.orange.shade400,
                imagePath: 'assets/images/carrot.png',
                onTap: () {
                  // 보호자 화면으로 이동
                  Get.off(() => const GuardianHomeView());
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(thickness: 1),
              ),
              _buildOptionCard(
                title: '간병인을\n요청하고 싶다면',
                buttonText: '간병인',
                buttonTextColor: Colors.orange.shade700,
                iconColor: Colors.blue.shade400,
                imagePath: 'assets/images/carrot_blue.png',
                onTap: () {
                  // 간병인 화면으로 이동
                  Get.off(() => const CaregiverHomeView());
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String buttonText,
    required Color buttonTextColor,
    required Color iconColor,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Handwriting',
                      color: buttonTextColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.chevron_right,
                    size: 24,
                    color: buttonTextColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: SizedBox(
              width: 70,
              height: 70,
              child: Image.asset(
                imagePath,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.eco,
                    size: 50,
                    color: iconColor,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
