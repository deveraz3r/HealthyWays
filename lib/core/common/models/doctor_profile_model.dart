import 'package:healthyways/core/common/custom_types/rating.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/entites/doctor_profile.dart';

class DoctorProfileModel extends DoctorProfile {
  DoctorProfileModel({
    required super.uid,
    required super.email,
    required super.fName,
    required super.lName,
    super.address,
    required super.gender,
    required super.preferedLanguage,
    required super.selectedRole,
    required super.bio,
    required super.specality,
    required super.qualification,
    required super.rating,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      fName: json['fName'] ?? '',
      lName: json['lName'] ?? '',
      address: json['address'],
      gender: json['gender'] ?? '',
      preferedLanguage: json['preferedLanguage'] ?? '',
      selectedRole: RoleExtension.fromJson(json['selectedRole'] ?? 'doctor'),
      bio: json['bio'] ?? '',
      specality: json['specality'] ?? '',
      qualification: json['qualification'] ?? '',
      rating: (json['rating'] as List<dynamic>?)?.map((e) => Rating.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fName': fName,
      'lName': lName,
      'address': address,
      'gender': gender,
      'preferedLanguage': preferedLanguage,
      'selectedRole': selectedRole.toJson(),
      'bio': bio,
      'specality': specality,
      'qualification': qualification,
      'rating': rating.map((e) => e.toJson()).toList(),
    };
  }
}
