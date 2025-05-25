import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/updates/domain/entites/medications_schedule_report.dart';
import 'package:healthyways/features/updates/domain/repositories/updates_repository.dart';

class GetAllMedicationScheduleReport
    implements UseCase<List<MedicationScheduleReport>, NoParams> {
  final UpdatesRepository repository;
  GetAllMedicationScheduleReport(this.repository);

  @override
  Future<Either<Failure, List<MedicationScheduleReport>>> call(params) async {
    return await repository.getAllMedicationsScheduleReports();
  }
}
