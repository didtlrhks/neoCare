import 'package:get/get.dart';
import '../models/guardian_model.dart';

class GuardianController extends GetxController {
  // Guardian 모델 인스턴스
  late Guardian _guardian;
  Guardian get guardian => _guardian;

  // 현재 선택된 탭 인덱스
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // 알림 설정
  bool _isAutoDeleteEnabled = true;
  bool get isAutoDeleteEnabled => _isAutoDeleteEnabled;

  @override
  void onInit() {
    super.onInit();
    // 초기 Guardian 객체 생성
    _guardian = Guardian(
      id: DateTime.now().toString(),
      name: '김네오',
      phoneNumber: '010-9876-5432',
      isProfileCompleted: false,
      careRequests: [],
    );
  }

  // 탭 변경
  void changeIndex(int index) {
    _currentIndex = index;
    update();
  }

  // 사용자 이름 업데이트
  void updateUserName(String newName) {
    _guardian = Guardian(
      id: _guardian.id,
      name: newName,
      phoneNumber: _guardian.phoneNumber,
      profileImageUrl: _guardian.profileImageUrl,
      isProfileCompleted: _guardian.isProfileCompleted,
      careRequests: _guardian.careRequests,
    );
    update();
  }

  // 알림 설정 토글
  void toggleAutoDelete() {
    _isAutoDeleteEnabled = !_isAutoDeleteEnabled;
    update();
  }

  // 간병 요청 추가
  void addCareRequest(Map<String, dynamic> careData) {
    final newRequest = CareRequest.fromJson(careData);
    if (!_isDuplicateRequest(newRequest.requestId)) {
      final updatedRequests = [..._guardian.careRequests, newRequest];
      _guardian = Guardian(
        id: _guardian.id,
        name: _guardian.name,
        phoneNumber: _guardian.phoneNumber,
        profileImageUrl: _guardian.profileImageUrl,
        isProfileCompleted: _guardian.isProfileCompleted,
        careRequests: updatedRequests,
      );
      update();
    }
  }

  // 간병 요청 제거
  void removeCareRequest(String requestId) {
    final updatedRequests = _guardian.careRequests
        .where((request) => request.requestId != requestId)
        .toList();
    _guardian = Guardian(
      id: _guardian.id,
      name: _guardian.name,
      phoneNumber: _guardian.phoneNumber,
      profileImageUrl: _guardian.profileImageUrl,
      isProfileCompleted: _guardian.isProfileCompleted,
      careRequests: updatedRequests,
    );
    update();
  }

  // 중복 요청 체크
  bool _isDuplicateRequest(String requestId) {
    return _guardian.careRequests
        .any((request) => request.requestId == requestId);
  }
}
