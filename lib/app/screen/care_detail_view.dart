import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'guardian_home_view.dart';
import 'quotation_detail_view.dart';
import 'payment_check_view.dart';

class CareDetailView extends StatefulWidget {
  final String requestId;

  const CareDetailView({super.key, required this.requestId});

  @override
  State<CareDetailView> createState() => _CareDetailViewState();
}

class _CareDetailViewState extends State<CareDetailView> {
  Map<String, dynamic>? _careData;

  @override
  void initState() {
    super.initState();
    _loadCareData();
  }

  // 요청 ID에 해당하는 간병 데이터 찾기
  void _loadCareData() {
    for (var careData in GuardianHomeView.allCareRequests) {
      if (careData['requestId'] == widget.requestId) {
        setState(() {
          _careData = careData;
        });
        break;
      }
    }
  }

  // 간병 요청 삭제 메서드
  void _deleteCareRequest() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('간병 요청 취소'),
          content: const Text('간병 요청을 취소하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('아니오'),
            ),
            TextButton(
              onPressed: () {
                // 간병 요청 취소 로직 구현
                GuardianHomeView.allCareRequests.removeWhere(
                  (careData) => careData['requestId'] == widget.requestId,
                );

                Navigator.of(context).pop();
                Get.back();
                Get.snackbar(
                  '간병 요청 취소',
                  '간병 요청이 취소되었습니다.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text('예'),
            ),
          ],
        );
      },
    );
  }

  // 견적 보기 메서드
  void _showQuotationView() {
    Get.to(() => QuotationView(requestId: widget.requestId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('간병 상세정보',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          // 오른쪽 상단에 삭제 버튼 추가
          TextButton.icon(
            onPressed: _deleteCareRequest,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              '삭제',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _careData == null
          ? const Center(child: CircularProgressIndicator())
          : _buildDetailContent(),
    );
  }

  Widget _buildDetailContent() {
    final patientInfo = _careData!['patientInfo'] ?? {};
    final String patientGender = patientInfo['gender'] ?? '정보 없음';
    final String patientAge = patientInfo['birthYear'] ?? '정보 없음';
    final String patientCareGrade = patientInfo['careGrade'] ?? '정보 없음';
    final String patientMobility = patientInfo['mobility'] ?? '정보 없음';
    final String patientDiagnosis = patientInfo['diagnosis'] ?? '정보 없음';
    final String patientNotes = patientInfo['notes'] ?? '정보 없음';

    final String requestId = _careData!['requestId'] ?? '요청 ID 없음';
    final String careType = _careData!['careType'] ?? '단순간병';
    final String? startDate = _careData!['startDate'];
    final String? endDate = _careData!['endDate'];
    final String? startTime = _careData!['startTime'];
    final String? endTime = _careData!['endTime'];
    final String dateRange = '$startDate  ~  $endDate';
    final String timeRange = '$startTime  ~  $endTime';
    final String address = _careData!['address'] ?? '주소 정보 없음';
    final String detailedAddress = _careData!['detailedAddress'] ?? '';
    final String fullAddress = '$address $detailedAddress';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 간병 요청 번호
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '간병요청 번호',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    requestId,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 간병 정보
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '간병정보',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('간병 분류', careType),
                  _buildInfoRow('간병 기간', dateRange),
                  _buildInfoRow('간병 시간', timeRange),
                  _buildInfoRow('간병 장소', fullAddress),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 환자 정보
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '환자정보',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('나이', patientAge),
                  _buildInfoRow('성별', patientGender),
                  _buildInfoRow('장기요양등급', patientCareGrade),
                  _buildInfoRow('거동가능여부', patientMobility),
                  const SizedBox(height: 8),
                  const Text(
                    '진단명',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    patientDiagnosis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '추가 특이사항',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    patientNotes,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 견적보기 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _showQuotationView,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  '견적보기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // 결제 진행 버튼
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // 결제 완료 화면으로 이동
                  Get.to(() => PaymentCheckView(requestId: requestId));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6960AD),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  '결제 진행하기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

// 견적 정보 화면
class QuotationView extends StatelessWidget {
  final String requestId;

  const QuotationView({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    // 간병인 정보 (예시 데이터)
    final Map<String, dynamic> caregiverInfo = {
      'name': '유네오',
      'type': '일반 간병인',
      'gender': '남자',
      'fee': '20,000원',
    };

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title:
            const Text('받은 견적', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 16),
            // 안내 텍스트 컨테이너
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAECF7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD1D5F0),
                  width: 1,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFF6960AD),
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '견적 정보',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6960AD),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '자세히 보기를 클릭하면 상세한 결제 금액을 확인할 수 있습니다.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '결제 후 간병인과 매칭이 이루어 집니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 간병인 카드 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: Color(0xFF6960AD),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '간병인 견적',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6960AD).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '시간제',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6960AD),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 간병인 카드
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 간병인 정보 섹션
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        // 간병인 프로필 이미지
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(
                              color: const Color(0xFFEAEAEA),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/carrot.png',
                              width: 40,
                              height: 40,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 35,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // 간병인 정보 텍스트
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                caregiverInfo['name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    caregiverInfo['gender'] == '남자'
                                        ? Icons.male
                                        : Icons.female,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${caregiverInfo['type']} · ${caregiverInfo['gender']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // 별점과 리뷰
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '4.8',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(12개의 리뷰)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // 간병인 프로필 보기 버튼
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextButton(
                            onPressed: () {
                              // 간병인 프로필 페이지로 이동
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              '프로필',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                      height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

                  // 가격 정보 섹션
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6960AD)
                                        .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: Color(0xFF6960AD),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  '1일 간병비',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              caregiverInfo['fee'],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6960AD),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        // 자세히 보기 버튼
                        GestureDetector(
                          onTap: () {
                            // 결제 상세 페이지로 이동
                            Get.to(() =>
                                QuotationDetailView(requestId: requestId));
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '자세히 보기',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }
}
