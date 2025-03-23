import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neocare/app/guardian_screen/care_type_selection_view.dart';

class CareRequestView extends StatefulWidget {
  const CareRequestView({super.key});

  @override
  State<CareRequestView> createState() => _CareRequestViewState();
}

class _CareRequestViewState extends State<CareRequestView> {
  CareType? selectedCareType;

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
              '간병 유형을 선택해 주세요.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // 기간제 옵션
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCareOption(
              title: '기간제(상주)',
              isSelected: selectedCareType == CareType.longTerm,
              onTap: () {
                setState(() {
                  selectedCareType = CareType.longTerm;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          // 시간제 옵션
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCareOption(
              title: '시간제',
              isSelected: selectedCareType == CareType.shortTerm,
              onTap: () {
                setState(() {
                  selectedCareType = CareType.shortTerm;
                });
              },
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
                onPressed: selectedCareType != null
                    ? () {
                        final String careTypeName =
                            selectedCareType == CareType.longTerm
                                ? '기간제(상주)'
                                : '시간제';

                        final Map<String, dynamic> careData = {
                          'careType': careTypeName,
                          'isActive': true,
                        };

                        Get.to(() => CareTypeSelectionView(careData: careData));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedCareType != null
                      ? Colors.black
                      : Colors.grey[300],
                  foregroundColor:
                      selectedCareType != null ? Colors.white : Colors.black38,
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

  Widget _buildCareOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                'assets/images/carrot.png',
                color: isSelected ? Colors.black : Colors.grey.shade400,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum CareType {
  longTerm,
  shortTerm,
}
