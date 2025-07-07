import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';

class RemoveMyProvider implements UseCase<void, RemoveMyProviderParams> {
  final PatientRepository repository;
  RemoveMyProvider(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveMyProviderParams params) async {
    return await repository.removeMyProvider(params.providerId);
  }
}

class RemoveMyProviderParams {
  final String providerId;
  RemoveMyProviderParams({required this.providerId});
}
