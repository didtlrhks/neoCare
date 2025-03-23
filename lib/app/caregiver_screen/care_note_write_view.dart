import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CareNoteWriteView extends StatefulWidget {
  final String careId;
  final String patientName;

  const CareNoteWriteView(
      {super.key, required this.careId, required this.patientName});

  @override
  State<CareNoteWriteView> createState() => _CareNoteWriteViewState();
}

class _CareNoteWriteViewState extends State<CareNoteWriteView> {
  final TextEditingController _noteController = TextEditingController();
  final List<String> _uploadedImages = [];
  bool _isImagePickerVisible = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '간병 노트 작성',
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
      body: Column(
        children: [
          // 환자 정보 헤더
          _buildPatientHeader(),

          // 구분선
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // 노트 입력 영역
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 안내 텍스트
                  Text(
                    '오늘의 간병 내용을 작성해주세요.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 텍스트 입력 필드
                  Expanded(
                    child: TextField(
                      controller: _noteController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: '환자 상태, 특이사항, 식사량 등을 기록해주세요.',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                  ),

                  // 이미지 업로드 영역
                  if (_uploadedImages.isNotEmpty) _buildUploadedImagesGrid(),

                  // 이미지 선택 UI
                  if (_isImagePickerVisible) _buildImagePickerOptions(),
                ],
              ),
            ),
          ),

          // 하단 컨트롤 영역
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black12,
            ),
            child: const Center(
              child: Icon(
                Icons.person_outline,
                color: Colors.black54,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.patientName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedImagesGrid() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _uploadedImages.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    color: Colors.grey[600],
                    size: 40,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _uploadedImages.removeAt(index);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImagePickerOptions() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '이미지 첨부',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildImageSourceOption(
                icon: Icons.camera_alt_outlined,
                label: '카메라',
                onTap: () {
                  // 카메라로 이미지 촬영
                  setState(() {
                    _isImagePickerVisible = false;
                    // 예시로 이미지 추가
                    _uploadedImages.add('camera_image');
                  });
                },
              ),
              _buildImageSourceOption(
                icon: Icons.photo_library_outlined,
                label: '갤러리',
                onTap: () {
                  // 갤러리에서 이미지 선택
                  setState(() {
                    _isImagePickerVisible = false;
                    // 예시로 이미지 추가
                    _uploadedImages.add('gallery_image');
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Icon(
              icon,
              size: 30,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // 이미지 첨부 버튼
          InkWell(
            onTap: () {
              setState(() {
                _isImagePickerVisible = !_isImagePickerVisible;
              });
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.grey[700],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 저장 버튼
          Expanded(
            child: SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: _noteController.text.trim().isNotEmpty
                    ? () {
                        // 노트 저장 처리
                        Get.back();
                        Get.snackbar(
                          '알림',
                          '간병 노트가 저장되었습니다.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '저장하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _noteController.text.trim().isNotEmpty
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
