import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/entites/profile.dart';
import 'package:healthyways/features/auth/data/models/profile_model.dart';
import 'package:healthyways/features/auth/data/models/doctor_profile_model.dart';
import 'package:healthyways/core/common/models/patient_profile_model.dart';
import 'package:healthyways/features/auth/data/models/pharmacist_profile_model.dart';

class ProfileFactory {
  static Profile createProfileFromJson(Map<String, dynamic> json) {
    final role = RoleExtension.fromJson(json['selectedRole'] ?? "patient");

    switch (role) {
      case Role.patient:
        return PatientProfileModel.fromJson(json);
      case Role.doctor:
        return DoctorProfileModel.fromJson(json);
      case Role.pharmacist:
        return PharmacistProfileModel.fromJson(json);
      default:
        return ProfileModel.fromJson(json);
    }
  }
}
