import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'guardian_home_view.dart';
import 'care_note_view.dart';

class ProgressCareView extends StatefulWidget {
  final String requestId;

  const ProgressCareView({super.key, required this.requestId});

  @override
  State<ProgressCareView> createState() => _ProgressCareViewState();
}

class _ProgressCareViewState extends State<ProgressCareView> {
  Map<String, dynamic>? _careData;

  @override
  void initState() {
    super.initState();
    _loadCareData();
  }

  // 요청 ID에 해당하는 간병 데이터 찾기
  void _loadCareData() {
    // requestId가 sample_로 시작하는 경우 (최간병 카드에서 온 경우) 샘플 데이터 생성
    if (widget.requestId.startsWith('sample_')) {
      setState(() {
        _careData = {
          'requestId': widget.requestId,
          'careType': '단순간병',
          'startDate': '2024.04.23',
          'endDate': '2024.04.23',
          'startTime': '07:35',
          'endTime': '20:35',
          'address': '경기 양주시 부흥로 1907번길',
          'detailedAddress': '182 (고읍동) 홍진빌딩 2층',
          'isActive': true,
        };
      });
      return;
    }

    // 일반적인 경우: allCareRequests에서 데이터 찾기
    for (var careData in GuardianHomeView.allCareRequests) {
      if (careData['requestId'] == widget.requestId) {
        setState(() {
          _careData = careData;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('진행 중인 간병',
            style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // 결제 취소 기능
              Get.snackbar(
                '결제 취소',
                '결제 취소 기능은 준비 중입니다.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text(
              '결제취소',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: _careData == null
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    // 간병인 정보 (예시 데이터)
    final Map<String, dynamic> caregiverInfo = {
      'name': '유네오',
      'type': '일반 간병인',
      'gender': '남자',
      'phone': '010-9876-5432',
    };

    // 간병 정보
    final String careType = _careData!['careType'] ?? '단순간병';
    final String startDate = _careData!['startDate'] ?? '';
    final String endDate = _careData!['endDate'] ?? '';
    final String startTime = _careData!['startTime'] ?? '';
    final String endTime = _careData!['endTime'] ?? '';
    final String address = _careData!['address'] ?? '';
    final String detailedAddress = _careData!['detailedAddress'] ?? '';
    final String fullAddress = '$address $detailedAddress';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 간병인 정보 섹션
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Text(
              '간병인 정보',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 간병인 프로필 카드
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                children: [
                  // 프로필 이미지
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/carrot.png',
                        width: 60,
                        height: 60,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 간병인 이름
                  Text(
                    caregiverInfo['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 간병인 정보
                  Text(
                    '${caregiverInfo['type']} · ${caregiverInfo['gender']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // 연락처 정보
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  '연락처',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  caregiverInfo['phone'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // 문의하기 기능
                    Get.snackbar(
                      '문의하기',
                      '문의하기 기능은 준비 중입니다.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    minimumSize: const Size(80, 36),
                  ),
                  child: const Text(
                    '문의하기',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 간병 정보 섹션
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text(
              '간병정보',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 간병 정보 리스트
          _buildInfoItem('간병분류', careType),
          _buildInfoItem('간병유형', '기간제'),
          _buildInfoItem('간병기간', '$startDate ~ $endDate'),
          _buildInfoItem('돌봄시간', '$startTime ~ $endTime'),
          _buildInfoItem('간병장소', fullAddress),

          const SizedBox(height: 30),

          // 지도 영역
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey[200],
            child: const Center(
              child: Text(
                'KAKAO MAP API',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 간병노트 보기 버튼
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // 간병노트 보기 페이지로 이동
                  Get.to(() => CareNoteView(requestId: widget.requestId));
                },
                icon: const Icon(Icons.note_alt),
                label: const Text('간병노트 보기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String content) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
