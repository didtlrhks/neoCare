import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'patient_info_view.dart';

class CareLocationView extends StatefulWidget {
  final Map<String, dynamic>? careData;

  const CareLocationView({super.key, this.careData});

  @override
  State<CareLocationView> createState() => _CareLocationViewState();
}

class _CareLocationViewState extends State<CareLocationView> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailAddressController =
      TextEditingController();
  bool _isNextEnabled = false;

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_checkInputs);
    _detailAddressController.addListener(_checkInputs);
  }

  void _checkInputs() {
    setState(() {
      _isNextEnabled = _addressController.text.isNotEmpty &&
          _detailAddressController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _addressController.removeListener(_checkInputs);
    _detailAddressController.removeListener(_checkInputs);
    _addressController.dispose();
    _detailAddressController.dispose();
    super.dispose();
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
              '간병을 제공받을 위치를 입력해 주세요.',
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: '주소 검색',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // 주소 검색 로직 구현
                      _addressController.text = '서울시 강남구 역삼동 123';
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text('검색'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 상세 주소
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '상세 주소',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _detailAddressController,
              decoration: InputDecoration(
                hintText: '상세 주소 입력',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
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
                        // 이전 페이지에서 받은 데이터와 현재 페이지의 데이터 병합
                        final Map<String, dynamic> updatedCareData = {
                          ...widget.careData ?? {},
                          'address': _addressController.text,
                          'detailAddress': _detailAddressController.text,
                        };

                        Get.to(
                            () => PatientInfoView(careData: updatedCareData));
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
