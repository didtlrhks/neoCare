import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'care_period_selection_view.dart';

class CareTypeSelectionView extends StatefulWidget {
  const CareTypeSelectionView({super.key});

  @override
  State<CareTypeSelectionView> createState() => _CareTypeSelectionViewState();
}

class _CareTypeSelectionViewState extends State<CareTypeSelectionView> {
  String? selectedType;

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedType = '기간제(상주)';
                });
              },
              child: _buildCareTypeOption(
                title: '기간제(상주)',
                icon: 'assets/images/carrot.png',
                isSelected: selectedType == '기간제(상주)',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedType = '시간제';
                });
              },
              child: _buildCareTypeOption(
                title: '시간제',
                icon: 'assets/images/carrot.png',
                isSelected: selectedType == '시간제',
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: selectedType != null
                    ? () {
                        Get.to(() => const CarePeriodSelectionView());
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedType != null
                      ? Colors.black
                      : Colors.grey.shade200,
                  foregroundColor: selectedType != null
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

  Widget _buildCareTypeOption({
    required String title,
    required String icon,
    required bool isSelected,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.black : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Image.asset(
              icon,
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
    );
  }
}
