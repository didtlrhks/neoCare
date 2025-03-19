import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CareLocationView extends StatefulWidget {
  const CareLocationView({super.key});

  @override
  State<CareLocationView> createState() => _CareLocationViewState();
}

class _CareLocationViewState extends State<CareLocationView> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _detailAddressController =
      TextEditingController();
  bool _isNextEnabled = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_checkInputs);
    _detailAddressController.addListener(_checkInputs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _detailAddressController.dispose();
    super.dispose();
  }

  void _checkInputs() {
    setState(() {
      _isNextEnabled = _searchController.text.isNotEmpty &&
          _detailAddressController.text.isNotEmpty;
    });
  }

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
              '간병장소는 어디인가요?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // 주소 검색
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '주소 검색',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 상세 주소
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _detailAddressController,
                    decoration: InputDecoration(
                      hintText: '상세 주소를 입력해 주세요',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
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
                onPressed: _isNextEnabled
                    ? () {
                        // TODO: 다음 단계로 이동
                        Get.snackbar('알림', '간병 장소가 선택되었습니다');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isNextEnabled ? Colors.black : Colors.grey.shade200,
                  foregroundColor:
                      _isNextEnabled ? Colors.white : Colors.grey.shade400,
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
}
