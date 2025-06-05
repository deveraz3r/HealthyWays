import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/measurements/domain/entites/measurement_entry.dart';
import 'package:healthyways/features/measurements/domain/repositories/measurement_repository.dart';

class AddMeasurementEntry implements UseCase<void, AddMeasurementEntryParams> {
  final MeasurementRepository repository;
  AddMeasurementEntry(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.addMeasurement(
      measurementEntry: params.measurementEntry,
    );
  }
}

class AddMeasurementEntryParams {
  MeasurementEntry measurementEntry;

  AddMeasurementEntryParams({required this.measurementEntry});
}
