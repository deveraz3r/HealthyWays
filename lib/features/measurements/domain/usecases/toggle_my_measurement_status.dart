import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/measurements/domain/repositories/measurement_repository.dart';

class ToggleMyMeasurementStatus
    implements UseCase<void, ToggleMyMeasurementStatusParams> {
  final MeasurementRepository repository;
  ToggleMyMeasurementStatus(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.toggleMyMeasurementStatus(id: params.id);
  }
}

class ToggleMyMeasurementStatusParams {
  String id;

  ToggleMyMeasurementStatusParams({required this.id});
}
