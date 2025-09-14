import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/entites/pharmacist_profile.dart';

class PharmacistProfileModel extends PharmacistProfile {
  PharmacistProfileModel({
    required super.uid,
    required super.email,
    required super.fName,
    required super.lName,
    required super.gender,
    super.address,
    required super.preferedLanguage,
    required super.selectedRole,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
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

  factory PharmacistProfileModel.fromJson(Map<String, dynamic> json) {
    return PharmacistProfileModel(
      uid: json['uid'] ?? "",
      email: json['email'] ?? "",
      fName: json['fName'] ?? "",
      lName: json['lName'] ?? "",
      address: json['address'] != null ? json['address'] ?? "" : null,
      gender: json['gender'] ?? "",
      preferedLanguage: json['preferedLanguage'] ?? "",
      selectedRole: RoleExtension.fromJson(json['selectedRole']),
    );
  }

  PharmacistProfileModel copyWith({
    String? uid,
    String? email,
    String? fName,
    String? lName,
    String? gender,
    String? address,
    String? preferedLanguage,
    Role? selectedRole,
  }) {
    return PharmacistProfileModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      preferedLanguage: preferedLanguage ?? this.preferedLanguage,
      selectedRole: selectedRole ?? this.selectedRole,
    );
  }
}
