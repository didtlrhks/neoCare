import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'care_note_detail_view.dart';
import 'care_note_write_view.dart';

class CareNoteView extends StatelessWidget {
  const CareNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시 데이터 - 실제로는 API나 DB에서 가져올 데이터
    const bool hasNotes = true; // 노트 유무 상태

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '간병 노트',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: hasNotes ? _buildNotesView() : _buildEmptyView(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => const CareNoteWriteView(
                    careId: '3',
                    patientName: '이영희',
                  ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit_note, size: 24),
                SizedBox(width: 8),
                Text(
                  '간병노트 작성',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 174,
            height: 174,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '174 × 174',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '간병인 이용 내역이 없습니다.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '간병을 요청해 주세요.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 32),
            child: Text(
              'NEO CARE',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black26,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesView() {
    // 임시 데이터 - 실제로는 API나 DB에서 가져올 데이터
    final List<Map<String, dynamic>> noteList = [
      {
        'date': '2024년 4월 23일',
        'notes': [
          {
            'time': '11:00',
            'content':
                '오늘은 환자분의 기분이 매우 좋으셨습니다. 점심 식사도 잘 하셨고, 오후에는 가벼운 스트레칭도 함께 했습니다.',
            'imageUrl': 'sample_image',
          },
          {
            'time': '15:00',
            'content': '오후 산책을 30분 정도 했습니다. 걸음걸이가 많이 호전되었습니다.',
          },
        ],
      },
      {
        'date': '2024년 4월 22일',
        'notes': [
          {
            'time': '12:00',
            'content': '식사 시간에 약 복용을 도와드렸습니다. 오늘은 특별히 기침이 덜하셨습니다.',
            'imageUrl': 'sample_image',
          },
        ],
      },
    ];

    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder: (context, index) {
        final dateData = noteList[index];
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Get.to(() => CareNoteDetailView(
                    date: dateData['date'],
                    notes: List<Map<String, dynamic>>.from(dateData['notes']),
                  ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateData['date'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.edit_note,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '간병 노트',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
