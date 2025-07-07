import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/allergies/data/datasources/allergies_remote_data_source.dart';
import 'package:healthyways/features/allergies/data/models/allergie_model.dart';
import 'package:healthyways/features/allergies/domain/entities/allergy.dart';
import 'package:healthyways/features/allergies/domain/repositories/allergie_repository.dart';

class AllergiesRepositoryImpl implements AllergiesRepository {
  final AllergiesRemoteDataSource dataSource;

  const AllergiesRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Allergy>>> getAllAllergieEntries() async {
    try {
      final result = await dataSource.getAllAllergieEntries();
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createAllergieEntry(Allergy allergie) async {
    try {
      await dataSource.createAllergieEntry(AllergieModel.fromEntity(allergie));
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllergieEntry(String id) async {
    try {
      await dataSource.deleteAllergieEntry(id);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Allergy>> updateAllergieEntry({
    required String id,
    required String title,
    required String body,
  }) async {
    try {
      final response = await dataSource.updateAllergieEntry(id: id, title: title, body: body);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
