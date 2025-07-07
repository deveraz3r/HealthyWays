import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';

class GetMyProviders implements UseCase<List<String>, NoParams> {
  final PatientRepository repository;
  GetMyProviders(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getMyProviders();
  }
}
