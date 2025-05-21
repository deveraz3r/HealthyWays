import 'package:healthyways/core/common/custom_types/role.dart';

class Profile {
  String uid;
  String email;
  String fName;
  String lName;
  String? address;
  String gender;
  String preferedLanguage;
  Role selectedRole;

  Profile({
    required this.uid,
    required this.email,
    required this.fName,
    required this.lName,
    this.address,
    required this.gender,
    required this.preferedLanguage,
    required this.selectedRole,
  });
}
