import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'caregiverinfo_view.dart';
import 'care_note_write_view.dart';
import 'caregiver_job_search_view.dart';
import 'caregiver_notification_view.dart';
import 'caregiver_profile_view.dart';

class CaregiverHomeView extends StatefulWidget {
  const CaregiverHomeView({super.key});

  @override
  State<CaregiverHomeView> createState() => _CaregiverHomeViewState();
}

class _CaregiverHomeViewState extends State<CaregiverHomeView> {
  int _selectedIndex = 0;
  final bool _isProfileCompleted = false;
  final List<Map<String, dynamic>> _careRequests = [
    {
      'requestId': '1',
      'location': '서울시 강남구 삼성동',
      'patientName': '홍길동',
      'patientAge': 78,
      'patientGender': '남성',
      'careType': '24시간 간병',
      'startDate': '2024-05-01',
      'endDate': '2024-05-10',
      'status': '수락 대기 중',
    },
    {
      'requestId': '2',
      'location': '서울시 서초구 반포동',
      'patientName': '김철수',
      'patientAge': 65,
      'patientGender': '남성',
      'careType': '주간 간병',
      'startDate': '2024-05-05',
      'endDate': '2024-05-15',
      'status': '수락 대기 중',
    },
  ];

  final List<Map<String, dynamic>> _ongoingCares = [
    {
      'careId': '3',
      'location': '서울시 송파구 잠실동',
      'patientName': '이영희',
      'patientAge': 72,
      'patientGender': '여성',
      'careType': '24시간 간병',
      'startDate': '2024-04-25',
      'endDate': '2024-05-05',
      'status': '진행 중',
      'guardianName': '이진수',
      'guardianContact': '010-1234-5678',
    },
  ];

  final List<Widget> _pages = [
    const _HomePage(),
    const CaregiverJobSearchView(),
    const CaregiverNotificationView(),
    const CaregiverProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '네오케어 간병인',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.search),
            label: '일감찾기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: '알림',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '내 정보',
          ),
        ],
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  final bool _isProfileCompleted = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 요약 정보
          _buildProfileSummary(),

          const SizedBox(height: 16),

          // 새로운 간병 요청 탭
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                // 간병 요청 작성 페이지로 이동
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
                        '간병요청작성',
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

          // 진행 중인 간병 카드
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                // 진행 중인 간병 상세 페이지로 이동
                Get.to(() => const CareNoteWriteView(
                      careId: '3',
                      patientName: '이영희',
                    ));
              },
              child: _buildOngoingCareCardNew({
                'careId': '3',
                'location': '서울시 송파구 잠실동',
                'patientName': '이영희',
                'patientAge': 72,
                'patientGender': '여성',
                'careType': '24시간 간병',
                'startDate': '2024-04-25',
                'endDate': '2024-05-05',
                'status': '진행 중',
                'guardianName': '이진수',
                'guardianContact': '010-1234-5678',
              }),
            ),
          ),

          const SizedBox(height: 30),

          const SizedBox(height: 80), // 바텀 네비게이션 여백
        ],
      ),
    );
  }

  Widget _buildProfileSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isProfileCompleted) ...[
            // 프로필 미완성 시 가이드
            const Text(
              '프로필을 완성하고 간병을 시작하세요!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '프로필을 완성하면 간병 요청을 받을 수 있습니다.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const CaregiverInfoView());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '프로필 완성하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ] else ...[
            // 프로필 완성 시 요약 정보
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 36,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '홍길동',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '서울 강남구, 서초구, 송파구',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 프로필 활성화 상태 표시
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '프로필 활성화됨',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOngoingCareCardNew(Map<String, dynamic> care) {
    // 시간제 아이콘과 텍스트가 있는 카드
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
                // 시간제 버튼
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

                // 시작제 버튼
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.watch_later_outlined,
                          size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      Text(
                        '시간제',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 환자 이름 행
            Row(
              children: [
                const Icon(Icons.person_outline,
                    size: 20, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  care['patientName'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 날짜
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 20, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  '${care['startDate']} ~ ${care['endDate']}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 시간
            const Row(
              children: [
                Icon(Icons.access_time, size: 20, color: Colors.black54),
                SizedBox(width: 8),
                Text(
                  '07:35 ~ 20:35',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 간병 노트 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 간병 노트 작성 페이지로 이동
                    Get.to(() => CareNoteWriteView(
                          careId: care['careId'],
                          patientName: care['patientName'],
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.edit_note, size: 18, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        '간병노트 보기',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
