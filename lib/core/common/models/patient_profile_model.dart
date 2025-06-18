import 'package:healthyways/core/common/custom_types/my_measurements.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';

class PatientProfileModel extends PatientProfile {
  PatientProfileModel({
    required super.uid,
    required super.email,
    required super.fName,
    required super.lName,
    required super.gender,
    required super.preferedLanguage,
    required super.selectedRole,

    required super.myMeasurements,
    super.race,
    super.address,
    required super.isMarried,
    required super.emergencyContacts,
    required super.insuranceIds,

    required super.globalVisibility,

    required super.allergiesVisibility,
    required super.immunizationsVisibility,
    required super.labReportsVisibility,
    required super.diariesVisibility,
    required super.measurementsVisibility,
    super.createdAt,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      uid: json['uid'] ?? "",
      email: json['email'] ?? "",
      fName: json['fName'] ?? "",
      lName: json['lName'] ?? "",
      gender: json['gender'] ?? "",
      preferedLanguage: json['preferedLanguage'] ?? "",
      selectedRole: RoleExtension.fromJson(json['selectedRole'] ?? 'patient'),
      myMeasurements:
          (json['myMeasurements'] as List<dynamic>?)
              ?.map((e) => MyMeasurements.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      race: json['race']?.toString(),
      isMarried: json['isMarried'] ?? false,
      emergencyContacts: List<String>.from(json['emergencyContacts'] ?? []),
      insuranceIds: List<String>.from(json['insuranceIds'] ?? []),
      globalVisibility: Visibility.fromJson(json['globalVisibility'] ?? {}),
      allergiesVisibility: Visibility.fromJson(json['allergiesVisibility'] ?? {}),
      immunizationsVisibility: Visibility.fromJson(json['immunizationVisibility'] ?? {}),
      labReportsVisibility: Visibility.fromJson(json['labReportsVisibility'] ?? {}),
      diariesVisibility: Visibility.fromJson(json['diariesVisibility'] ?? {}),
      measurementsVisibility: Visibility.fromJson(json['measurementsVisibility'] ?? {}),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fName': fName,
      'lName': lName,
      'gender': gender,
      'preferedLanguage': preferedLanguage,
      'selectedRole': selectedRole.toJson(),
      'myMeasurements': myMeasurements.map((e) => e.toJson()).toList(),
      'race': race,
      'isMarried': isMarried,
      'emergencyContacts': emergencyContacts,
      'insuranceIds': insuranceIds,
      'globalVisibility': globalVisibility.toJson(),
      'allergiesVisibility': allergiesVisibility.toJson(),
      'immunizationVisibility': immunizationsVisibility.toJson(),
      'labReportsVisibility': labReportsVisibility.toJson(),
      'diaryVisibility': diariesVisibility.toJson(),
      'measurementsVisibility': measurementsVisibility.toJson(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  PatientProfileModel copyWith({
    String? uid,
    String? email,
    String? fName,
    String? lName,
    String? gender,
    String? preferedLanguage,
    Role? selectedRole,
    List<MyMeasurements>? myMeasurements,
    String? race,
    bool? isMarried,
    List<String>? emergencyContacts,
    List<String>? insuranceIds,
    Visibility? globalVisibility,
    Visibility? allergiesVisibility,
    Visibility? immunizationsVisibility,
    Visibility? labReportsVisibility,
    Visibility? diariesVisibility,
    Visibility? measurementsVisibility,
    DateTime? createdAt,
  }) {
    return PatientProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      gender: gender ?? this.gender,
      preferedLanguage: preferedLanguage ?? this.preferedLanguage,
      selectedRole: selectedRole ?? this.selectedRole,
      myMeasurements: myMeasurements ?? this.myMeasurements,
      race: race ?? this.race,
      isMarried: isMarried ?? this.isMarried,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      insuranceIds: insuranceIds ?? this.insuranceIds,
      globalVisibility: globalVisibility ?? this.globalVisibility,
      allergiesVisibility: allergiesVisibility ?? this.allergiesVisibility,
      immunizationsVisibility: immunizationsVisibility ?? this.immunizationsVisibility,
      labReportsVisibility: labReportsVisibility ?? this.labReportsVisibility,
      diariesVisibility: diariesVisibility ?? this.diariesVisibility,
      measurementsVisibility: measurementsVisibility ?? this.measurementsVisibility,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
