import 'package:healthyways/core/common/custom_types/my_measurements.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/common/entites/profile.dart';

class PatientProfile extends Profile {
  final List<MyMeasurements> myMeasurements;
  final String? race; // Nullable
  final bool isMarried;
  final List<String> emergencyContacts;
  final List<String> insuranceIds;
  final Visibility globalVisibility;
  final Visibility allergiesVisibility;
  final Visibility immunizationsVisibility;
  final Visibility labReportsVisibility;
  final Visibility diariesVisibility;
  final DateTime? createdAt; // Nullable

  PatientProfile({
    required super.uid,
    required super.email,
    required super.fName,
    required super.lName,
    required super.gender,
    required super.preferedLanguage,
    required super.selectedRole,

    required this.myMeasurements,
    this.race,
    required this.isMarried,
    required this.emergencyContacts,
    required this.insuranceIds,
    required this.globalVisibility,
    required this.allergiesVisibility,
    required this.immunizationsVisibility,
    required this.labReportsVisibility,
    required this.diariesVisibility,
    this.createdAt,
  });
}
