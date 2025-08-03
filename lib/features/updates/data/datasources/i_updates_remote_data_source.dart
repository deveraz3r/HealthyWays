import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/entites/assigned_medication_report.dart';

abstract interface class IUpdatesRemoteDataSource {
  Future<List<AssignedMedicationReport>> getAllMedicationScheduleReport({
    required String uid,
    required Role role,
  });
}
