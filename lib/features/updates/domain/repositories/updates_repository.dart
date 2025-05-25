import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/updates/domain/entites/medications_schedule_report.dart';

abstract interface class UpdatesRepository {
  Future<Either<Failure, List<MedicationScheduleReport>>>
  getAllMedicationsScheduleReports();
}
