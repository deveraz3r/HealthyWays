import 'package:get/get.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/updates/domain/entites/medications_schedule_report.dart';
import 'package:healthyways/features/updates/domain/usecases/get_all_medication_schedule_report.dart';

class UpdatesController extends GetxController {
  final GetAllMedicationScheduleReport _getAllMedicationScheduleReport;

  UpdatesController({
    required GetAllMedicationScheduleReport getAllMedicationScheduleReport,
  }) : _getAllMedicationScheduleReport = getAllMedicationScheduleReport;

  final allMedicationScheduleReport =
      StateController<Failure, List<MedicationScheduleReport>>();

  Future<void> getAllMedicationScheduleReports() async {
    allMedicationScheduleReport.setLoading();

    final result = await _getAllMedicationScheduleReport(NoParams());

    result.fold(
      (failure) => allMedicationScheduleReport.setError(failure),
      (success) => allMedicationScheduleReport.setData(success),
    );
  }
}
