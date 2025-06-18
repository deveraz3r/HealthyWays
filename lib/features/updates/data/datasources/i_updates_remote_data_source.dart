import 'package:healthyways/core/common/entites/assigned_medication_report.dart';
import 'package:healthyways/features/updates/data/models/medication_schedule_report_model.dart';

abstract interface class IUpdatesRemoteDataSource {
  Future<List<AssignedMedicationReport>> getAllMedicationScheduleReport();
}
