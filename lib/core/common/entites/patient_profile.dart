// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:healthyways/core/common/custom_types/my_measurements.dart';
import 'package:healthyways/core/common/custom_types/visiblity.dart';
import 'package:healthyways/core/common/entites/profile.dart';
import 'package:healthyways/features/auth/data/models/profile_model.dart';

class PatientProfile extends Profile {
  String race;
  bool isMarried;
  List<String> emergencyContacts;
  List<String> insuranceIds;
  MyMeasurements myMeasurements;
  Visiblity globalVisiblity;
  Visiblity allergiesVisiblity;
  Visiblity immunizationsVisiblity;
  Visiblity labReportsVisiblity;
  Visiblity diariesVisiblity;

  PatientProfile({
    required super.uid,
    required super.email,
    required super.fName,
    required super.lName,
    super.address,
    required super.gender,
    required super.preferedLanguage,
    required super.selectedRole,

    required this.myMeasurements,
    required this.race,
    required this.isMarried,
    required this.emergencyContacts,
    required this.insuranceIds,
    required this.globalVisiblity,
    required this.allergiesVisiblity,
    required this.immunizationsVisiblity,
    required this.labReportsVisiblity,
    required this.diariesVisiblity,
  });
}
