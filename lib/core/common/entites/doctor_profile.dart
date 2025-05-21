import 'package:healthyways/core/common/custom_types/rating.dart';
import 'package:healthyways/core/common/entites/profile.dart';

class DoctorProfile extends Profile {
  String bio;
  String specality;
  String qualification;
  List<Rating> rating;

  DoctorProfile({
    required super.uid,
    required super.email,
    required super.fName,
    required super.lName,
    super.address,
    required super.gender,
    required super.preferedLanguage,
    required super.selectedRole,

    required this.bio,
    required this.specality,
    required this.qualification,
    required this.rating,
  });
}
