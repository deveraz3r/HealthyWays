import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';
import 'package:healthyways/features/measurements/domain/repositories/measurement_repository.dart';

class GetMeasurementEntries
    implements UseCase<List<MeasurementEntry>, GetAllMeasurementEntriesParams> {
  MeasurementRepository repository;
  GetMeasurementEntries(this.repository);
  @override
  Future<Either<Failure, List<MeasurementEntry>>> call(params) async {
    return await repository.getMeasurementEntries(
      patientId: params.patientId,
      measurementId: params.measurementId,
    );
  }
}

class GetAllMeasurementEntriesParams {
  String patientId;
  String measurementId;

  GetAllMeasurementEntriesParams({
    required this.patientId,
    required this.measurementId,
  });
}
