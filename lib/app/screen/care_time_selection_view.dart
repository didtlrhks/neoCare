import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'care_location_view.dart';

class CareTimeSelectionView extends StatefulWidget {
  final Map<String, dynamic>? careData;

  const CareTimeSelectionView({super.key, this.careData});

  @override
  State<CareTimeSelectionView> createState() => _CareTimeSelectionViewState();
}

class _CareTimeSelectionViewState extends State<CareTimeSelectionView> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

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
              '돌봄 시간을 선택해 주세요.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // 시작 시간
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '시작 시간',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectTime(context, isStart: true),
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          startTime != null ? _formatTime(startTime!) : '',
                          style: TextStyle(
                            fontSize: 16,
                            color: startTime != null
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                        ),
                        Icon(
                          Icons.access_time,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 종료 시간
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '종료 시간',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectTime(context, isStart: false),
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          endTime != null ? _formatTime(endTime!) : '',
                          style: TextStyle(
                            fontSize: 16,
                            color: endTime != null
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                        ),
                        Icon(
                          Icons.access_time,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // 다음 버튼
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (startTime != null && endTime != null)
                    ? () {
                        // 이전 데이터에 시간 정보 추가하여 다음 페이지로 전달
                        final Map<String, dynamic> updatedCareData = {
                          ...widget.careData ?? {},
                          'startTime': _formatTime(startTime!),
                          'endTime': _formatTime(endTime!),
                        };

                        Get.to(
                            () => CareLocationView(careData: updatedCareData));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (startTime != null && endTime != null)
                      ? Colors.black
                      : Colors.grey.shade200,
                  foregroundColor: (startTime != null && endTime != null)
                      ? Colors.white
                      : Colors.grey.shade400,
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

  Future<void> _selectTime(BuildContext context,
      {required bool isStart}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
          // 시작 시간이 종료 시간보다 뒤라면, 적절한 처리
          if (endTime != null && _isTimeAfter(startTime!, endTime!)) {
            endTime = null; // 종료 시간 초기화
          }
        } else {
          // 종료 시간이 시작 시간보다 앞이면 선택 불가
          if (startTime != null && _isTimeBefore(picked, startTime!)) {
            Get.snackbar('알림', '종료 시간은 시작 시간 이후여야 합니다');
            return;
          }
          endTime = picked;
        }
      });
    }
  }

  // 시간 포맷팅 함수
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // 시간 비교 함수: time1이 time2보다 이후인지
  bool _isTimeAfter(TimeOfDay time1, TimeOfDay time2) {
    return time1.hour > time2.hour ||
        (time1.hour == time2.hour && time1.minute > time2.minute);
  }

  // 시간 비교 함수: time1이 time2보다 이전인지
  bool _isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    return time1.hour < time2.hour ||
        (time1.hour == time2.hour && time1.minute < time2.minute);
  }
}
