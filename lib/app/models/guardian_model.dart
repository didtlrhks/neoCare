class Guardian {
  final String id;
  final String name;
  final String phoneNumber;
  final String? profileImageUrl;
  final bool isProfileCompleted;
  final List<CareRequest> careRequests;

  Guardian({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.profileImageUrl,
    this.isProfileCompleted = false,
    this.careRequests = const [],
  });

  factory Guardian.fromJson(Map<String, dynamic> json) {
    return Guardian(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      isProfileCompleted: json['isProfileCompleted'] as bool? ?? false,
      careRequests: (json['careRequests'] as List<dynamic>?)
              ?.map((e) => CareRequest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'isProfileCompleted': isProfileCompleted,
      'careRequests': careRequests.map((e) => e.toJson()).toList(),
    };
  }
}

class CareRequest {
  final String requestId;
  final String careType;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final bool isActive;
  final PatientInfo patientInfo;

  CareRequest({
    required this.requestId,
    required this.careType,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    this.isActive = true,
    required this.patientInfo,
  });

  factory CareRequest.fromJson(Map<String, dynamic> json) {
    return CareRequest(
      requestId: json['requestId'] as String,
      careType: json['careType'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      isActive: json['isActive'] as bool? ?? true,
      patientInfo:
          PatientInfo.fromJson(json['patientInfo'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'careType': careType,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'isActive': isActive,
      'patientInfo': patientInfo.toJson(),
    };
  }
}

class PatientInfo {
  final String gender;
  final String birthYear;
  final String careGrade;
  final bool canMove;
  final String? diseases;
  final String? notes;

  PatientInfo({
    required this.gender,
    required this.birthYear,
    required this.careGrade,
    required this.canMove,
    this.diseases,
    this.notes,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      gender: json['gender'] as String,
      birthYear: json['birthYear'] as String,
      careGrade: json['careGrade'] as String,
      canMove: json['canMove'] as bool,
      diseases: json['diseases'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'birthYear': birthYear,
      'careGrade': careGrade,
      'canMove': canMove,
      'diseases': diseases,
      'notes': notes,
    };
  }
}
