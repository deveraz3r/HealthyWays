import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/assigned_medication_report.dart';
import 'package:healthyways/core/error/failure.dart';

abstract interface class UpdatesRepository {
  Future<Either<Failure, List<AssignedMedicationReport>>> getAllMedicationsScheduleReports();
}
