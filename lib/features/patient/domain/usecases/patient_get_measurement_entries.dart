import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';

class PatientGetMeasurementEntries implements UseCase<List<MeasurementEntry>, PatientGetMeasurementEntriesParams> {
  PatientRepository repository;
  PatientGetMeasurementEntries(this.repository);
  @override
  Future<Either<Failure, List<MeasurementEntry>>> call(params) async {
    return await repository.getMeasurementEntries(patientId: params.patientId, measurementId: params.measurementId);
  }
}

class PatientGetMeasurementEntriesParams {
  String patientId;
  String measurementId;

  PatientGetMeasurementEntriesParams({required this.patientId, required this.measurementId});
}
