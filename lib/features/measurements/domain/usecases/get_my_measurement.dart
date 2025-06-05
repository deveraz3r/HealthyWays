import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/measurements/domain/entites/preset_measurement.dart';
import 'package:healthyways/features/measurements/domain/repositories/measurement_repository.dart';

class GetMyMeasurements implements UseCase<List<PresetMeasurement>, NoParams> {
  final MeasurementRepository repository;
  GetMyMeasurements(this.repository);

  @override
  Future<Either<Failure, List<PresetMeasurement>>> call(NoParams params) async {
    return await repository.getMyMeasurements();
  }
}
