import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/pharmacist_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/pharmacist/data/datasources/pharmacist_remote_data_source.dart';
import 'package:healthyways/features/auth/data/models/pharmacist_profile_model.dart';
import 'package:healthyways/features/pharmacist/domain/repositories/pharmacist_repository.dart';

class PharmacistRepositoryImpl implements PharmacistRepository {
  final PharmacistRemoteDataSource remoteDataSource;

  PharmacistRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PharmacistProfile>> getPharmacistById(
    String uid,
  ) async {
    try {
      final pharmacist = await remoteDataSource.getPharmacistProfileById(uid);

      if (pharmacist == null) return Left(Failure("Pharmacist not found"));

      return Right(pharmacist);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePharmacist(
    PharmacistProfile pharmacist,
  ) async {
    try {
      await remoteDataSource.updatePharmacistProfile(
        pharmacist as PharmacistProfileModel,
      );
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PharmacistProfile>>> getAllPharmacists() async {
    try {
      final pharmacists = await remoteDataSource.getAllPharmacists();
      return Right(pharmacists);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
