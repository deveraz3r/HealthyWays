import 'package:healthyways/core/common/entites/profile.dart';

class PharmacistProfile extends Profile {
  PharmacistProfile({
    required super.uid,
    required super.email,
    required super.fName,
    required super.lName,
    required super.gender,
    super.address,
    required super.preferedLanguage,
    required super.selectedRole,
  });
}
