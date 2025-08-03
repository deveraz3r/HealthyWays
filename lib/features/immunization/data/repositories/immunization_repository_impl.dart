import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/immunization/data/datasources/immunization_remote_data_source.dart';
import 'package:healthyways/features/immunization/data/models/immunization_model.dart';
import 'package:healthyways/features/immunization/domain/entities/immunization.dart';
import 'package:healthyways/features/immunization/domain/repositories/immunization_repository.dart';

class ImmunizationRepositoryImpl implements ImmunizationRepository {
  final ImmunizationRemoteDataSource dataSource;

  const ImmunizationRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Immunization>>> getAllImmunizationEntries({
    required String uid,
  }) async {
    try {
      final result = await dataSource.getAllImmunizations(uid: uid);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createImmunizationEntry(
    Immunization immunization,
  ) async {
    try {
      await dataSource.createImmunizationEntry(
        ImmunizationModel.fromEntity(immunization),
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteImmunizationEntry(String id) async {
    try {
      await dataSource.deleteImmunizationEntry(id);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Immunization>> updateImmunizationEntry({
    required String id,
    required String title,
    required String body,
    required String? providerId,
  }) async {
    try {
      final response = await dataSource.updateImmunizationEntry(
        id: id,
        title: title,
        body: body,
        providerId: providerId,
      );
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
