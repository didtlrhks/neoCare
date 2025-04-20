import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/guardian_model.dart';
import '../controllers/guardian_controller.dart';
import 'care_request_view.dart';
import 'care_detail_view.dart';
import 'progress_care_view.dart';
import 'name_change_view.dart';

class GuardianHomeView extends StatefulWidget {
  final Map<String, dynamic>? careData;

  // 모든 인스턴스에서 공유할 정적 리스트 추가
  static final List<Map<String, dynamic>> allCareRequests = [];

  const GuardianHomeView({super.key, this.careData});

  @override
  State<GuardianHomeView> createState() => _GuardianHomeViewState();
}

class _GuardianHomeViewState extends State<GuardianHomeView> {
  late final GuardianController controller;

  @override
  void initState() {
    super.initState();
    // 이미 초기화된 컨트롤러를 가져옵니다
    controller = Get.find<GuardianController>();

    if (widget.careData != null && (widget.careData!['isActive'] == true)) {
      controller.addCareRequest(widget.careData!);
    }

    // 디버그 메시지를 통해 요청 데이터 확인
    debugPrint('initState - _careData: ${widget.careData}');
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
    return GetBuilder<GuardianController>(
      init: controller, // 여기에 컨트롤러를 명시적으로 지정
      builder: (controller) => Scaffold(
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
          currentIndex: controller.currentIndex,
          onTap: controller.changeIndex,
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
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (controller.currentIndex) {
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
    final careRequests = controller.guardian.careRequests;
    final bool hasActiveRequests = careRequests.isNotEmpty;

    // 요청 목록을 시간 역순으로 정렬 (최신순)
    final sortedRequests = List<CareRequest>.from(careRequests);
    sortedRequests.sort((a, b) => b.requestId.compareTo(a.requestId));

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
                .map((careRequest) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => CareDetailView(
                                requestId: careRequest.requestId,
                              ));
                        },
                        child: _buildActiveCareCard(careRequest),
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
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    '알림',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        controller.isAutoDeleteEnabled ? '자동' : '수동',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: controller.isAutoDeleteEnabled
                              ? Colors.teal[600]
                              : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: controller.isAutoDeleteEnabled,
                        onChanged: (value) => controller.toggleAutoDelete(),
                        activeColor: Colors.teal[600],
                        activeTrackColor: Colors.teal[100],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(() => RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 14, height: 1.4),
                        children: [
                          const TextSpan(
                            text: '알림 설정이 ',
                          ),
                          TextSpan(
                            text: controller.isAutoDeleteEnabled ? '자동' : '수동',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: controller.isAutoDeleteEnabled
                                  ? Colors.teal[600]
                                  : Colors.grey[800],
                            ),
                          ),
                          const TextSpan(
                            text: '으로 설정되어 있을 경우\n7일이 지난 알림은 ',
                          ),
                          const TextSpan(
                            text: '자동 삭제',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: ' 됩니다.',
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),

        // 구분선
        Container(
          height: 8,
          color: Colors.grey[100],
        ),

        // 알림 목록 (스크롤 가능)
        Expanded(
          child: ListView(
            children: [
              // 간병노트 알림
              _buildNotificationItem(
                icon: Icons.assignment_outlined,
                title: '간병노트',
                message: '2024년 04월 20일 간병노트가 등록되었습니다.',
                time: '1시간 전',
                onDelete: () {
                  // 삭제 기능 구현
                  Get.snackbar('알림', '간병노트 알림이 삭제되었습니다.',
                      snackPosition: SnackPosition.BOTTOM);
                },
              ),

              // 구분선
              Divider(height: 1, thickness: 1, color: Colors.grey[200]),

              // 받은견적 알림
              _buildNotificationItem(
                icon: Icons.article_outlined,
                title: '받은견적',
                message: '김네오 님이 견적을 보냈습니다.',
                time: '1시간 전',
                onDelete: () {
                  // 삭제 기능 구현
                  Get.snackbar('알림', '견적 알림이 삭제되었습니다.',
                      snackPosition: SnackPosition.BOTTOM);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 알림 아이템 위젯
  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required VoidCallback onDelete,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 제목과 메시지
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          // 오른쪽 시간과 삭제 버튼 영역
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 시간 표시
              Text(
                time,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),

              const SizedBox(height: 8),

              // 삭제 버튼
              InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '삭제',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 섹션
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 상단 제목
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '내 정보',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 프로필 사진
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/carrot.png',
                        width: 60,
                        height: 60,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey[400],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 사용자 이름
                  Obx(() => Text(
                        controller.guardian.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),

                  const SizedBox(height: 6),

                  // 사용자 이메일 또는 기타 정보
                  Text(
                    '일반 사용자',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 프로필 수정 버튼
                  OutlinedButton(
                    onPressed: () {
                      // 프로필 수정 화면으로 이동
                      Get.to(() => NameChangeView(
                            initialName: controller.guardian.name,
                            onNameChanged: controller.updateUserName,
                          ));
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: Text(
                      '프로필 수정',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 설정 섹션
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 16, bottom: 8),
                    child: Text(
                      '계정 설정',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),

                  // 계정 설정 옵션들
                  _buildSettingItem(
                    icon: Icons.phone_outlined,
                    title: '연락처',
                    subtitle: '010-9876-5432',
                    onTap: () {
                      Get.snackbar('알림', '연락처 변경 기능은 준비 중입니다.',
                          snackPosition: SnackPosition.BOTTOM);
                    },
                  ),

                  _buildDivider(),

                  _buildSettingItem(
                    icon: Icons.lock_outline,
                    title: '비밀번호 변경',
                    onTap: () {
                      Get.snackbar('알림', '비밀번호 변경 기능은 준비 중입니다.',
                          snackPosition: SnackPosition.BOTTOM);
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 이용 내역 섹션
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 16, bottom: 8),
                    child: Text(
                      '서비스 이용',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    icon: Icons.history_outlined,
                    title: '간병인 이용내역',
                    onTap: () {
                      Get.snackbar('알림', '간병인 이용내역 기능은 준비 중입니다.',
                          snackPosition: SnackPosition.BOTTOM);
                    },
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.settings_outlined,
                    title: '설정',
                    onTap: () {
                      Get.snackbar('알림', '설정 기능은 준비 중입니다.',
                          snackPosition: SnackPosition.BOTTOM);
                    },
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.help_outline,
                    title: '고객센터',
                    onTap: () {
                      Get.snackbar('알림', '고객센터 기능은 준비 중입니다.',
                          snackPosition: SnackPosition.BOTTOM);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 앱 정보 섹션
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 16, bottom: 8),
                    child: Text(
                      '앱 정보',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    icon: Icons.info_outline,
                    title: '앱 버전',
                    subtitle: '1.0.0',
                    onTap: () {},
                    showArrow: false,
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.sync,
                    title: '탈퇴신청',
                    titleColor: Colors.red[700],
                    onTap: () {
                      Get.snackbar('알림', '탈퇴신청 기능은 준비 중입니다.',
                          snackPosition: SnackPosition.BOTTOM);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // 로그아웃 버튼
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.snackbar('알림', '로그아웃 되었습니다.',
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey[800],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: const Text(
                    '로그아웃',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 56,
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                size: 20,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: titleColor ?? Colors.black87,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCareCard() {
    // 항상 진행 중인 간병이 없는 상태의 카드 표시
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

  Widget _buildActiveCareCard(CareRequest careRequest) {
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
                        careRequest.careType,
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
                Text(
                  '요청번호: ${careRequest.requestId.substring(careRequest.requestId.length - 4)}',
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
                  careRequest.careType,
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
                      careRequest.patientInfo.gender == '남자'
                          ? Icons.man
                          : Icons.woman,
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
                  '${careRequest.startDate}  ~  ${careRequest.endDate}',
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
                  '${careRequest.startTime}  ~  ${careRequest.endTime}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
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
