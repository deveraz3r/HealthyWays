import 'package:healthyways/core/common/entites/profile.dart';
import 'package:healthyways/core/common/custom_types/role.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required super.uid,
    required super.fName,
    required super.email,
    required super.lName,
    super.address,
    required super.gender,
    required super.preferedLanguage,
    required super.selectedRole,
  });

  ProfileModel copyWith({
    String? uid,
    String? email,
    String? fName,
    String? lName,
    String? address,
    String? gender,
    String? preferedLanguage,
    Role? selectedRole,
  }) {
    return ProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      preferedLanguage: preferedLanguage ?? this.preferedLanguage,
      selectedRole: selectedRole ?? this.selectedRole,
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
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      fName: json['fName'] ?? '',
      lName: json['lName'] ?? '',
      address: json['address'],
      gender: json['gender'] ?? '',
      preferedLanguage: json['preferedLanguage'] ?? '',
      selectedRole: RoleExtension.fromJson(json['selectedRole']),
    );
  }
}
