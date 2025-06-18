import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/custom_types/my_measurements.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/measurements/domain/repositories/measurement_repository.dart';

class UpdateMyMeasurementReminderSettings implements UseCase<void, UpdateMyMeasurementReminderSettingsParams> {
  MeasurementRepository repository;
  UpdateMyMeasurementReminderSettings(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.updateMyMeasurementReminderSettings(myMeasurement: params.myMeasurement);
  }
}

class UpdateMyMeasurementReminderSettingsParams {
  MyMeasurements myMeasurement;

  UpdateMyMeasurementReminderSettingsParams({required this.myMeasurement});
}
