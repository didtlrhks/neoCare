import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CareNoteView extends StatefulWidget {
  final String requestId;

  const CareNoteView({super.key, required this.requestId});

  @override
  State<CareNoteView> createState() => _CareNoteViewState();
}

class _CareNoteViewState extends State<CareNoteView> {
  // 간병노트 데이터
  final List<Map<String, dynamic>> _noteList = [
    {
      'date': '2024년 4월 23일',
      'notes': [
        {
          'time': '09:30',
          'content': '환자 아침 식사 섭취 도움, 혈압 체크 (120/80)',
        },
        {
          'time': '11:00',
          'content': '간단한 재활 운동 진행, 보행 연습 10분',
        },
        {
          'time': '13:30',
          'content': '점심 식사 도움, 약 복용 확인',
        }
      ],
      'images': [
        'assets/images/care_note_image.png',
        'assets/images/carrot.png',
        'assets/images/care_note_image.png',
      ]
    },
    {
      'date': '2024년 4월 22일',
      'notes': [
        {
          'time': '09:00',
          'content': '아침 식사 및 약 복용 도움',
        },
        {
          'time': '12:00',
          'content': '점심 식사 도움 및 산책',
        },
        {
          'time': '18:00',
          'content': '저녁 식사 및 개인위생 도움',
        }
      ],
      'images': [
        'assets/images/care_note_image.png',
        'assets/images/carrot.png',
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            const Text('간병 노트', style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _buildNoteList(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                'assets/images/carrot.png',
                width: 30,
                height: 30,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '유네오',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '일반 간병인',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
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
    );
  }

  Widget _buildNoteList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _noteList.length,
      itemBuilder: (context, index) {
        final dateGroup = _noteList[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                dateGroup['date'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...dateGroup['notes'].map<Widget>((note) {
              return _buildNoteItem(note);
            }).toList(),

            // 날짜별 이미지 갤러리
            if (dateGroup['images'] != null &&
                (dateGroup['images'] as List).isNotEmpty)
              _buildImageGallery(dateGroup['images']),

            if (index < _noteList.length - 1)
              const Divider(
                color: Colors.grey,
                height: 32,
              ),
          ],
        );
      },
    );
  }

  Widget _buildNoteItem(Map<String, dynamic> note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6960AD).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    note['time'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6960AD),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    note['content'],
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 이미지가 있는 경우에만 표시
          if (note['imageUrl'] != null)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: const AssetImage('assets/images/care_note_image.png'),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // 이미지 로드 실패 시 기본 이미지
                  },
                ),
              ),
              child: note['imageUrl'] == 'sample_image'
                  ? Container() // 샘플 이미지가 있으면 텍스트 표시 안함
                  : Center(
                      child: Text(
                        '간병 이미지',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            ),
        ],
      ),
    );
  }

  // 이미지 갤러리 위젯
  Widget _buildImageGallery(List<dynamic> images) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              '오늘의 간병 사진',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  height: 120,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
