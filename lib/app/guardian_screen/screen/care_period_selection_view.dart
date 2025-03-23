import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'care_time_selection_view.dart';

class CarePeriodSelectionView extends StatefulWidget {
  final Map<String, dynamic>? careData;

  const CarePeriodSelectionView({super.key, this.careData});

  @override
  State<CarePeriodSelectionView> createState() =>
      _CarePeriodSelectionViewState();
}

class _CarePeriodSelectionViewState extends State<CarePeriodSelectionView> {
  DateTime? startDate;
  DateTime? endDate;

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
              '간병 기간을 선택해 주세요.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // 시작일
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '시작일',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context, isStart: true),
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
                          startDate != null
                              ? '${startDate!.year}.${startDate!.month.toString().padLeft(2, '0')}.${startDate!.day.toString().padLeft(2, '0')}'
                              : '',
                          style: TextStyle(
                            fontSize: 16,
                            color: startDate != null
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today_outlined,
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
          // 종료일
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '종료일',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context, isStart: false),
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
                          endDate != null
                              ? '${endDate!.year}.${endDate!.month.toString().padLeft(2, '0')}.${endDate!.day.toString().padLeft(2, '0')}'
                              : '',
                          style: TextStyle(
                            fontSize: 16,
                            color: endDate != null
                                ? Colors.black
                                : Colors.grey.shade400,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today_outlined,
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
                onPressed: (startDate != null && endDate != null)
                    ? () {
                        // 날짜 포맷팅
                        final String formattedStartDate =
                            '${startDate!.year}.${startDate!.month.toString().padLeft(2, '0')}.${startDate!.day.toString().padLeft(2, '0')}';
                        final String formattedEndDate =
                            '${endDate!.year}.${endDate!.month.toString().padLeft(2, '0')}.${endDate!.day.toString().padLeft(2, '0')}';

                        // 이전 데이터에 기간 정보 추가
                        final Map<String, dynamic> updatedCareData = {
                          ...widget.careData ?? {},
                          'startDate': formattedStartDate,
                          'endDate': formattedEndDate,
                        };

                        Get.to(() =>
                            CareTimeSelectionView(careData: updatedCareData));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (startDate != null && endDate != null)
                      ? Colors.black
                      : Colors.grey.shade200,
                  foregroundColor: (startDate != null && endDate != null)
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

  Future<void> _selectDate(BuildContext context,
      {required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12),
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
          startDate = picked;
          // 시작일이 종료일보다 뒤라면 종료일도 같은 날짜로 설정
          if (endDate != null && startDate!.isAfter(endDate!)) {
            endDate = startDate;
          }
        } else {
          // 종료일이 시작일보다 앞이면 선택 불가
          if (startDate != null && picked.isBefore(startDate!)) {
            Get.snackbar('알림', '종료일은 시작일 이후여야 합니다');
            return;
          }
          endDate = picked;
        }
      });
    }
  }
}
