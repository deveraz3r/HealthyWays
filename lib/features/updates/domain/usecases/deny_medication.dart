import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';

class DenyMedicaiton implements UseCase<void, DenyMedicationParams> {
  @override
  Future<Either<Failure, void>> call(params) async {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class DenyMedicationParams {}
