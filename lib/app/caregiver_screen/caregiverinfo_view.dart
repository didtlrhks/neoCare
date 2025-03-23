import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'service_area_view.dart';

class CaregiverInfoView extends StatefulWidget {
  const CaregiverInfoView({super.key});

  @override
  State<CaregiverInfoView> createState() => _CaregiverInfoViewState();
}

class _CaregiverInfoViewState extends State<CaregiverInfoView> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedGender = '';
  int _uploadedImagesCount = 0;
  final List<String> _selectedAreas = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _navigateToServiceAreaSelection() {
    Get.to(() => ServiceAreaView(
          selectedAreas: _selectedAreas,
          onAreasSelected: (areas) {
            setState(() {
              _selectedAreas.clear();
              _selectedAreas.addAll(areas);
            });
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '프로필 등록',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프로필 등록 타이틀
              const Text(
                '프로필 등록',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // 프로필 이미지 영역
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 프로필 이미지 원형 컨테이너
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/carrot.png',
                          width: 100,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey[400],
                            );
                          },
                        ),
                      ),
                    ),

                    // 카메라 아이콘 버튼
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 이름 입력 필드 라벨
              _buildLabelWithDot('이름'),

              const SizedBox(height: 8),

              // 이름 입력 필드
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: '이름을 입력해주세요.',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 24),

              // 성별 선택 라벨
              _buildLabelWithDot('성별'),

              const SizedBox(height: 8),

              // 성별 선택 버튼
              Row(
                children: [
                  Expanded(
                    child:
                        _buildGenderButton('남자', _selectedGender == '남자', () {
                      setState(() {
                        _selectedGender = '남자';
                      });
                    }),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                        _buildGenderButton('여자', _selectedGender == '여자', () {
                      setState(() {
                        _selectedGender = '여자';
                      });
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 보유 자격증 영역
              const Text(
                '보유 자격증',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              // 이미지 등록 설명 텍스트
              Text(
                '첨부 이미지는 5장까지 등록 가능합니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 12),

              // 이미지 등록 버튼
              InkWell(
                onTap: () {
                  // 이미지 업로드 기능 추가
                  setState(() {
                    if (_uploadedImagesCount < 5) {
                      _uploadedImagesCount++;
                    }
                  });
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '사진 $_uploadedImagesCount/5',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 서비스 가능 지역 섹션
              InkWell(
                onTap: _navigateToServiceAreaSelection,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '서비스 가능 지역 (최대 5개)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_selectedAreas.isEmpty) ...[
                        const Center(
                          child: Text(
                            '터치하여 지역 선택하기',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Icon(
                            Icons.add_circle_outline,
                            size: 24,
                            color: Colors.grey,
                          ),
                        ),
                      ] else ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedAreas
                              .map((area) => _buildAreaChip(area))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 저장 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isFormValid()
                      ? () {
                          // 프로필 등록 성공
                          Get.back();
                          Get.snackbar(
                            '알림',
                            '프로필이 등록되었습니다.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isFormValid() ? Colors.black : Colors.grey[200],
                    foregroundColor:
                        _isFormValid() ? Colors.white : Colors.grey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.grey[200],
                    disabledForegroundColor: Colors.grey,
                  ),
                  child: const Text(
                    '저장',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    return _nameController.text.trim().isNotEmpty &&
        _selectedGender.isNotEmpty &&
        _selectedAreas.isNotEmpty;
  }

  // 라벨과 빨간 점 위젯
  Widget _buildLabelWithDot(String label) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  // 성별 선택 버튼 위젯
  Widget _buildGenderButton(String text, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // 선택된 지역 칩 위젯
  Widget _buildAreaChip(String area) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        area,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}
