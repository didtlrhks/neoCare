import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'guardian_home_view.dart';

class PatientInfoView extends StatefulWidget {
  final Map<String, dynamic>? careData;

  const PatientInfoView({super.key, this.careData});

  @override
  State<PatientInfoView> createState() => _PatientInfoViewState();
}

class _PatientInfoViewState extends State<PatientInfoView> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime? _selectedBirthDate;
  String? _selectedGender;
  String? _selectedDegree;
  String? _selectedMobility;

  @override
  void dispose() {
    _ageController.dispose();
    _diagnosisController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _selectedBirthDate != null &&
        _selectedGender != null &&
        _selectedDegree != null &&
        _selectedMobility != null;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                '환자 상태를 입력해 주세요.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // 나이
              _buildLabelWithDot('나이'),
              const SizedBox(height: 8),
              _buildAgeInput(),
              const SizedBox(height: 20),

              // 성별
              _buildLabelWithDot('성별'),
              const SizedBox(height: 8),
              _buildGenderSelection(),
              const SizedBox(height: 20),

              // 장기요양 등급
              _buildLabelWithDot('장기요양 등급'),
              const SizedBox(height: 8),
              _buildDropdown(),
              const SizedBox(height: 20),

              // 거동 가능 여부
              _buildLabelWithDot('거동 가능 여부'),
              const SizedBox(height: 8),
              _buildMobilitySelection(),
              const SizedBox(height: 20),

              // 질환 및 질병
              const Text(
                '질환 및 질병',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(_diagnosisController, '입력 예: sample1234'),
              const SizedBox(height: 20),

              // 기타 특이사항
              const Text(
                '기타 특이사항',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildMultilineTextField(_noteController),
              const SizedBox(height: 40),

              // 간병 요청 버튼
              _buildSubmitButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelWithDot(String label) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildAgeInput() {
    return SizedBox(
      height: 55,
      child: InkWell(
        onTap: () => _selectBirthDate(context),
        child: IgnorePointer(
          child: TextField(
            controller: _ageController,
            decoration: InputDecoration(
              hintText: _selectedBirthDate != null ? null : '1995',
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
              suffixIcon: InkWell(
                onTap: () => _selectBirthDate(context),
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime initialDate =
        _selectedBirthDate ?? DateTime(currentDate.year - 20);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
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

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _ageController.text = DateFormat('yyyy').format(picked);
      });
    }
  }

  Widget _buildGenderSelection() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedGender = '남자';
              });
            },
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: _selectedGender == '남자' ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _selectedGender == '남자'
                      ? Colors.black
                      : Colors.grey.shade200,
                ),
              ),
              child: Center(
                child: Text(
                  '남자',
                  style: TextStyle(
                    color:
                        _selectedGender == '남자' ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedGender = '여자';
              });
            },
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: _selectedGender == '여자' ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _selectedGender == '여자'
                      ? Colors.black
                      : Colors.grey.shade200,
                ),
              ),
              child: Center(
                child: Text(
                  '여자',
                  style: TextStyle(
                    color:
                        _selectedGender == '여자' ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedDegree,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'SelectValue',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
          items: ['1등급', '2등급', '3등급', '4등급', '5등급', '없음'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedDegree = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildMobilitySelection() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedMobility = '가능';
              });
            },
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: _selectedMobility == '가능' ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _selectedMobility == '가능'
                      ? Colors.black
                      : Colors.grey.shade200,
                ),
              ),
              child: Center(
                child: Text(
                  '가능',
                  style: TextStyle(
                    color:
                        _selectedMobility == '가능' ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedMobility = '불가능';
              });
            },
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: _selectedMobility == '불가능' ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _selectedMobility == '불가능'
                      ? Colors.black
                      : Colors.grey.shade200,
                ),
              ),
              child: Center(
                child: Text(
                  '불가능',
                  style: TextStyle(
                    color: _selectedMobility == '불가능'
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return SizedBox(
      height: 55,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
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
    );
  }

  Widget _buildMultilineTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isFormValid
            ? () {
                // 환자 정보 데이터 생성
                final patientData = {
                  'birthYear': _ageController.text,
                  'gender': _selectedGender,
                  'careGrade': _selectedDegree,
                  'mobility': _selectedMobility,
                  'diagnosis': _diagnosisController.text,
                  'notes': _noteController.text,
                };

                // 이전 화면에서 전달된 간병 데이터와 합치기
                final Map<String, dynamic> completeData = {
                  ...widget.careData ?? {},
                  'patientInfo': patientData,
                  'isActive': true,
                };

                // 완료 다이얼로그 표시
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 50,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '간병 요청이 완료되었습니다.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '요청하신 간병에 대한 정보는\n보호자 홈 화면에서 확인하실 수 있습니다.',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // 간병 요청 카드에 고유 ID 추가
                                final String uniqueId =
                                    '${DateTime.now().millisecondsSinceEpoch}_${(1000 + GuardianHomeView.allCareRequests.length)}';

                                final Map<String, dynamic> completeDataWithId =
                                    {
                                  ...completeData,
                                  'requestId': uniqueId,
                                };

                                // 디버그 메시지로 데이터 확인
                                debugPrint('간병 요청 완료: $completeDataWithId');
                                debugPrint('생성된 요청 ID: $uniqueId');

                                // 이전의 모든 화면 제거하고 홈 화면으로 이동
                                Get.offAll(
                                  () => GuardianHomeView(
                                      careData: completeDataWithId),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                '확인',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade200,
          disabledForegroundColor: Colors.grey.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: const Text(
          '간병요청',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
