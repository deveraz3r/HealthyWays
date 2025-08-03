import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/entites/assigned_medication_report.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/updates/data/datasources/i_updates_remote_data_source.dart';
import 'package:healthyways/features/updates/domain/entites/medications_schedule_report.dart';
import 'package:healthyways/features/updates/domain/repositories/updates_repository.dart';

class UpdatesRepositoryImpl implements UpdatesRepository {
  final IUpdatesRemoteDataSource dataSource;
  UpdatesRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<AssignedMedicationReport>>>
  getAllMedicationsScheduleReports({
    required String uid,
    required Role role,
  }) async {
    try {
      final allMedicationScheduleReports = await dataSource
          .getAllMedicationScheduleReport(uid: uid, role: role);

      return Right(allMedicationScheduleReports);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
