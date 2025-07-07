import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';

class AddMyProvider implements UseCase<void, AddMyProviderParams> {
  final PatientRepository repository;
  AddMyProvider(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.addMyProvider(params.providerId);
  }
}

class AddMyProviderParams {
  final String providerId;
  AddMyProviderParams({required this.providerId});
}
