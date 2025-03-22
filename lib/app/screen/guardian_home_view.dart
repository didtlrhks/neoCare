import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'care_request_view.dart';
import 'care_detail_view.dart';
import 'progress_care_view.dart';

class GuardianHomeView extends StatefulWidget {
  final Map<String, dynamic>? careData;

  // 모든 인스턴스에서 공유할 정적 리스트 추가
  static final List<Map<String, dynamic>> allCareRequests = [];

  const GuardianHomeView({super.key, this.careData});

  @override
  State<GuardianHomeView> createState() => _GuardianHomeViewState();
}

class _GuardianHomeViewState extends State<GuardianHomeView> {
  int _currentIndex = 0;
  Map<String, dynamic>? _careData;

  @override
  void initState() {
    super.initState();
    _careData = widget.careData ?? Get.arguments;

    // 새로운 간병 요청이 있으면 정적 리스트에 추가
    if (_careData != null && (_careData!['isActive'] == true)) {
      _addCareRequest(_careData!);
    }

    // 디버그 메시지를 통해 요청 데이터 확인
    debugPrint('initState - _careData: $_careData');
    debugPrint(
        'initState - allCareRequests: ${GuardianHomeView.allCareRequests.length}');
  }

  // 간병 요청을 리스트에 추가하는 메서드
  void _addCareRequest(Map<String, dynamic> careData) {
    debugPrint('_addCareRequest 호출됨: ${careData['requestId']}');
    debugPrint('현재 요청 수: ${GuardianHomeView.allCareRequests.length}');

    // 현재 등록된 요청 ID 목록 출력
    if (GuardianHomeView.allCareRequests.isNotEmpty) {
      debugPrint('현재 등록된 요청 ID:');
      for (var req in GuardianHomeView.allCareRequests) {
        debugPrint(' - ${req['requestId']}');
      }
    }

    // 중복 추가 방지를 위해 동일한 요청이 있는지 확인
    bool isDuplicate = false;
    for (var request in GuardianHomeView.allCareRequests) {
      if (_isSameRequest(request, careData)) {
        isDuplicate = true;
        debugPrint(
            '중복 발견: ${request['requestId']} == ${careData['requestId']}');
        break;
      }
    }

    if (!isDuplicate) {
      final newCareData = Map<String, dynamic>.from(careData);
      setState(() {
        GuardianHomeView.allCareRequests.add(newCareData);
      });
      debugPrint('간병 요청 추가됨: ${GuardianHomeView.allCareRequests.length}');
      debugPrint('추가된 요청 ID: ${newCareData['requestId']}');
    } else {
      debugPrint('중복된 간병 요청 발견되어 추가하지 않음');
    }
  }

  // 두 요청이 동일한지 확인하는 메서드
  bool _isSameRequest(
      Map<String, dynamic> request1, Map<String, dynamic> request2) {
    // 디버그 로그 추가
    debugPrint('요청 비교: ${request1['requestId']} vs ${request2['requestId']}');

    // 요청 ID가 있으면 ID로만 비교 (가장 확실한 방법)
    if (request1.containsKey('requestId') &&
        request2.containsKey('requestId')) {
      final String id1 = request1['requestId'].toString();
      final String id2 = request2['requestId'].toString();

      debugPrint('ID 비교 결과: ${id1 == id2 ? "동일함" : "다름"}');

      // ID가 다르면 다른 요청으로 간주 (동일한 ID 체크만으로 중복 판단)
      return id1 == id2;
    }

    // ID가 없는 경우에만 다른 속성으로 비교 (이전 코드 유지)
    debugPrint('ID 없음, 다른 속성으로 비교');

    // patientInfo의 동일성도 체크하여 중복 요청을 더 정확하게 구분합니다
    final patientInfo1 = request1['patientInfo'];
    final patientInfo2 = request2['patientInfo'];

    if (patientInfo1 != null && patientInfo2 != null) {
      // 환자 정보까지 비교하여 더 정확한 중복 체크
      final String p1Gender = patientInfo1['gender'] ?? '';
      final String p2Gender = patientInfo2['gender'] ?? '';
      final String p1CareGrade = patientInfo1['careGrade'] ?? '';
      final String p2CareGrade = patientInfo2['careGrade'] ?? '';

      // 환자 정보가 다르면 다른 요청으로 취급
      if (p1Gender != p2Gender || p1CareGrade != p2CareGrade) {
        return false;
      }
    }

    return request1['startDate'] == request2['startDate'] &&
        request1['endDate'] == request2['endDate'] &&
        request1['startTime'] == request2['startTime'] &&
        request1['endTime'] == request2['endTime'] &&
        request1['careType'] == request2['careType'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('NEO CARE',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: _buildCurrentView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: '간병인요청',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: '알림',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '내정보',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeView();
      case 1:
        return _buildCareRequestListView();
      case 2:
        return _buildNotificationView();
      case 3:
        return _buildProfileView();
      default:
        return _buildHomeView();
    }
  }

  Widget _buildHomeView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          // 상단 이미지 영역
          Center(
            child: Container(
              width: 300,
              height: 300,
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                  '480 × 480',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // 간병 요청하기 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                // CareRequestView로 이동
                Get.to(() => const CareRequestView());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6960AD),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit_note, size: 28, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        '간병요청하기',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          // 진행 중인 간병 섹션
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '진행 중인 간병',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),

          // 항상 빈 카드 표시
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildEmptyCareCard(),
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCaregiverRecruitmentCard(),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCareRequestListView() {
    final bool hasActiveRequests = GuardianHomeView.allCareRequests.isNotEmpty;

    debugPrint(
        '_buildCareRequestListView - 간병 요청 수: ${GuardianHomeView.allCareRequests.length}');
    for (int i = 0; i < GuardianHomeView.allCareRequests.length; i++) {
      final id = GuardianHomeView.allCareRequests[i]['requestId'] ?? '요청 ID 없음';
      debugPrint('요청 $i: $id');
    }

    // 요청 목록을 시간 역순으로 정렬 (최신순)
    final sortedRequests =
        List<Map<String, dynamic>>.from(GuardianHomeView.allCareRequests);
    sortedRequests.sort((a, b) {
      final idA = a['requestId']?.toString() ?? '';
      final idB = b['requestId']?.toString() ?? '';
      // ID가 타임스탬프 기반이므로 역순 정렬하면 최신 요청이 위로 올라옴
      return idB.compareTo(idA);
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '간병 요청 목록',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (hasActiveRequests)
            ...(sortedRequests
                .map((careData) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          // 클릭 시 상세 페이지로 이동
                          Get.to(() => CareDetailView(
                                requestId: careData['requestId'] ?? '',
                              ));
                        },
                        child: _buildActiveCareCard(careData),
                      ),
                    ))
                .toList())
          else
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        '진행 중인 간병 요청이 없습니다.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationView() {
    return const Center(
      child: Text(
        '알림 화면',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildProfileView() {
    return const Center(
      child: Text(
        '내 정보 화면',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildEmptyCareCard() {
    // 가장 최근에 결제 완료된 간병 요청 찾기
    Map<String, dynamic>? activeCare;

    for (var care in GuardianHomeView.allCareRequests) {
      if (care['isActive'] == true) {
        activeCare = care;
        break;
      }
    }

    // 진행 중인 간병이 있는 경우
    if (activeCare != null) {
      final String careType = activeCare['careType'] ?? '단순간병';
      final String? startDate = activeCare['startDate'];
      final String? endDate = activeCare['endDate'];
      final String? startTime = activeCare['startTime'];
      final String? endTime = activeCare['endTime'];
      final String dateRange = '$startDate  ~  $endDate';
      final String timeRange = '$startTime  ~  $endTime';
      final String requestId = activeCare['requestId'] ?? '';

      return GestureDetector(
        onTap: () {
          // 진행 중인 간병 상세 화면으로 이동
          Get.to(() => ProgressCareView(requestId: requestId));
        },
        child: Container(
          width: double.infinity,
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6960AD).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            size: 16,
                            color: Color(0xFF6960AD),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '진행 중',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6960AD),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  careType,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      dateRange,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      timeRange,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      '간병인',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '유네오',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF5F5F5),
                      ),
                      child: Image.asset(
                        'assets/images/carrot.png',
                        width: 20,
                        height: 20,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 진행 중인 간병이 없는 경우 기존 빈 카드 표시
    return Container(
      width: double.infinity,
      height: 200,
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
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '진행중인 간병이 없습니다.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '간병을 요청해 주세요.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActiveCareCard(Map<String, dynamic> careData) {
    // 보호자 정보
    final String patientGender = careData['patientInfo']?['gender'] ?? '';

    // 요청 ID
    final String requestId = careData['requestId'] ?? '요청 ID 없음';

    // 기간 정보
    final String? startDate = careData['startDate'];
    final String? endDate = careData['endDate'];
    final String dateRange = '$startDate  ~  $endDate';

    // 시간 정보
    final String? startTime = careData['startTime'];
    final String? endTime = careData['endTime'];
    final String timeRange = '$startTime  ~  $endTime';

    // 간병 타입
    final String careType = careData['careType'] ?? '단순간병';

    debugPrint('카드 생성 - ID: $requestId, 유형: $careType');

    return Container(
      width: double.infinity,
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.refresh, size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      Text(
                        '시간제',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right,
                          size: 16, color: Colors.grey[700]),
                    ],
                  ),
                ),

                const Spacer(),

                // 요청 ID를 짧게 표시
                Text(
                  '요청번호: ${requestId.length > 4 ? requestId.substring(requestId.length - 4) : requestId}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.medical_services_outlined,
                    size: 20, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  careType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Icon(
                      patientGender == '남자' ? Icons.man : Icons.woman,
                      size: 40,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 20, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  dateRange,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 20, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  timeRange,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            // 상세 보기 안내
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '상세 보기',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 14, color: Colors.grey[700]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaregiverRecruitmentCard() {
    // 예시 데이터로 샘플 requestId 생성
    final String sampleRequestId =
        "sample_${DateTime.now().millisecondsSinceEpoch}";

    return GestureDetector(
      onTap: () {
        // 간병인(최간병) 카드 클릭 시 ProgressCareView로 이동
        // 데이터가 없으므로 샘플 ID를 생성해서 전달
        Get.to(() => ProgressCareView(requestId: sampleRequestId));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[50],
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
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 시간제 아이콘과 텍스트
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.refresh,
                                  size: 16, color: Colors.grey[700]),
                              const SizedBox(width: 4),
                              Text(
                                '시간제',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.chevron_right,
                                  size: 16, color: Colors.grey[700]),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 최간병 텍스트
                    Row(
                      children: [
                        Icon(Icons.medical_services_outlined,
                            size: 20, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        const Text(
                          '최간병',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // 날짜
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 20, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        const Text(
                          '2024.04.23 ~ 2024.04.23',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // 시간
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 20, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        const Text(
                          '07:35 ~ 20:35',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 오른쪽 이미지 영역
            Container(
              width: 40,
              height: 40,
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                  '40 × 40',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
