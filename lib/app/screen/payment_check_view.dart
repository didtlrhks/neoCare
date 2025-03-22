import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'guardian_home_view.dart';

class PaymentCheckView extends StatelessWidget {
  final String requestId;

  const PaymentCheckView({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('결제하기', style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // 영수증 스타일 카드
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 2,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: DottedBorderPainter(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 체크 아이콘
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // 텍스트 - 첫 줄
                        const Text(
                          '간병비용 결제가',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // 텍스트 - 두번째 줄
                        const Text(
                          '완료되었습니다.',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 홈화면으로 가기 버튼
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // 간병 요청 삭제
                _removeCareRequest();

                // 홈 화면으로 이동
                Get.offAll(() => const GuardianHomeView());
              },
              icon: const Icon(Icons.home),
              label: const Text('홈화면으로 가기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 간병 요청 삭제 메서드
  void _removeCareRequest() {
    // 디버그 로그 추가
    debugPrint('결제 완료: 요청 ID $requestId 삭제 시도');
    debugPrint('삭제 전 요청 수: ${GuardianHomeView.allCareRequests.length}');

    // 해당 ID의 요청 삭제
    GuardianHomeView.allCareRequests
        .removeWhere((careData) => careData['requestId'] == requestId);

    debugPrint('삭제 후 요청 수: ${GuardianHomeView.allCareRequests.length}');

    // 삭제 완료 알림
    Get.snackbar(
      '결제 완료',
      '간병 요청이 완료되었습니다.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}

// 점선 테두리를 그리는 커스텀 페인터
class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const double dashWidth = 8;
    const double dashSpace = 4;
    const double radius = 20;

    // 위쪽 점선
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // 아래쪽 점선
    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
