import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/measurements/domain/entites/preset_measurement.dart';
import 'package:healthyways/features/measurements/domain/repositories/measurement_repository.dart';

class GetMyMeasurements
    implements UseCase<List<PresetMeasurement>, GetMyMeasurementsParams> {
  final MeasurementRepository repository;
  GetMyMeasurements(this.repository);

  @override
  Future<Either<Failure, List<PresetMeasurement>>> call(params) async {
    return await repository.getMyMeasurements(
      patientProfile: params.patientProfile,
    );
  }
}

class GetMyMeasurementsParams {
  final PatientProfile patientProfile;

  GetMyMeasurementsParams({required this.patientProfile});
}
