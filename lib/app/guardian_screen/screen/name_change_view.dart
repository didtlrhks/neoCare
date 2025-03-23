import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NameChangeView extends StatefulWidget {
  final String initialName;
  final Function(String) onNameChanged;

  const NameChangeView({
    super.key,
    required this.initialName,
    required this.onNameChanged,
  });

  @override
  State<NameChangeView> createState() => _NameChangeViewState();
}

class _NameChangeViewState extends State<NameChangeView> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text('프로필수정',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            )),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 구분선
          const Divider(height: 1, thickness: 1),

          // 제목 영역
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '프로필 수정',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 이름 입력 필드 라벨
          Padding(
            padding: const EdgeInsets.only(left: 32, bottom: 8),
            child: Row(
              children: [
                const Text(
                  '이름',
                  style: TextStyle(
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
            ),
          ),

          // 이름 입력 필드
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: '이름을 입력해 주세요.',
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
          ),

          // 하단 여백을 채우는 Spacer
          const Spacer(),

          // 저장 버튼
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // 이름이 비어있지 않은 경우에만 저장 처리
                  if (_nameController.text.trim().isNotEmpty) {
                    // 변경된 이름 전달
                    widget.onNameChanged(_nameController.text.trim());

                    // 저장 완료 메시지 및 이전 화면으로 이동
                    Get.back();
                    Get.snackbar(
                      '알림',
                      '프로필이 수정되었습니다.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    // 이름이 비어있을 경우 에러 메시지
                    Get.snackbar(
                      '알림',
                      '이름을 입력해주세요.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red[100],
                      colorText: Colors.red[800],
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
          ),
        ],
      ),
    );
  }
}
