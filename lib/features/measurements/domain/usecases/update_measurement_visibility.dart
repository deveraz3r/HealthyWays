import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/measurements/domain/repositories/measurement_repository.dart';

class UpdateMeasurementVisibility implements UseCase<void, UpdateMeasurementVisibilityParams> {
  MeasurementRepository repository;
  UpdateMeasurementVisibility(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.updateMeasurementVisibility(
      measurementId: params.measurementId,
      visibility: params.visibility,
    );
  }
}

class UpdateMeasurementVisibilityParams {
  String measurementId;
  Visibility visibility;

  UpdateMeasurementVisibilityParams({required this.measurementId, required this.visibility});
}
