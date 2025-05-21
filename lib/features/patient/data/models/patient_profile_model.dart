import 'package:healthyways/core/common/custom_types/my_measurements.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/custom_types/visiblity.dart';
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
    required super.race,
    required super.isMarried,
    required super.emergencyContacts,
    required super.insuranceIds,
    required super.globalVisiblity,
    required super.allergiesVisiblity,
    required super.immunizationsVisiblity,
    required super.labReportsVisiblity,
    required super.diariesVisiblity,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      uid: json['uid'] ?? "",
      email: json['email'] ?? "",
      fName: json['fName'] ?? "",
      lName: json['lName'] ?? "",
      gender: json['gender'] ?? "",
      preferedLanguage: json['preferedLanguage'] ?? "",
      selectedRole: RoleExtension.fromJson(json['selectedRole']),
      myMeasurements: MyMeasurements.fromJson(json['myMeasurements']),
      race: json['race'] ?? "",
      isMarried: json['isMarried'] ?? false,
      emergencyContacts: List<String>.from(json['emergencyContacts'] ?? []),
      insuranceIds: List<String>.from(json['insuranceIds'] ?? []),
      globalVisiblity: Visiblity.fromJson(json['globalVisiblity']),
      allergiesVisiblity: Visiblity.fromJson(json['allergiesVisiblity']),
      immunizationsVisiblity: Visiblity.fromJson(
        json['immunizationsVisiblity'],
      ),
      labReportsVisiblity: Visiblity.fromJson(json['labReportsVisiblity']),
      diariesVisiblity: Visiblity.fromJson(json['diariesVisiblity']),
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
      'myMeasurements': myMeasurements.toJson(),
      'race': race,
      'isMarried': isMarried,
      'emergencyContacts': emergencyContacts,
      'insuranceIds': insuranceIds,
      'globalVisiblity': globalVisiblity.toJson(),
      'allergiesVisiblity': allergiesVisiblity.toJson(),
      'immunizationsVisiblity': immunizationsVisiblity.toJson(),
      'labReportsVisiblity': labReportsVisiblity.toJson(),
      'diariesVisiblity': diariesVisiblity.toJson(),
    };
  }
}
