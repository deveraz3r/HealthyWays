import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/measurements/domain/repositories/measurement_repository.dart';

class GetMeasurementVisibility implements UseCase<Visibility, GetMeasurementVisibilityParams> {
  MeasurementRepository repository;
  GetMeasurementVisibility(this.repository);

  @override
  Future<Either<Failure, Visibility>> call(params) async {
    return await repository.getMeasurementVisibility(measurementId: params.measurementId);
  }
}

class GetMeasurementVisibilityParams {
  String measurementId;

  GetMeasurementVisibilityParams({required this.measurementId});
}
