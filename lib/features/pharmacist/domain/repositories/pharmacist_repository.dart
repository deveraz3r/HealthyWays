import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/pharmacist_profile.dart';
import 'package:healthyways/core/error/failure.dart';

abstract interface class PharmacistRepository {
  Future<Either<Failure, PharmacistProfile>> getPharmacistById(String uid);
  Future<Either<Failure, void>> updatePharmacist(PharmacistProfile pharmacist);
  Future<Either<Failure, List<PharmacistProfile>>> getAllPharmacists();
  Future<Either<Failure, void>> addMyPatient(String patientId);
}
