import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/features/medication/data/datasources/medications_remote_data_source.dart';
import 'package:healthyways/core/common/entites/medication.dart';
import 'package:healthyways/core/common/models/assigned_medication_model.dart';
import 'package:healthyways/core/common/models/medicine_schedule_model.dart';
import 'package:healthyways/core/common/entites/assigned_medication_report.dart';
import 'package:healthyways/features/medication/domain/repositories/medication_repository.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationsRemoteDataSource remoteDataSource;

  MedicationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Medicine>>> getAllMedicines() async {
    try {
      final allMedicines = await remoteDataSource.getAllMedicines();

      return Right(allMedicines);
    } on ServerException catch (e) {
      throw Left(Failure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, Medicine>> getMedicineById({required String id}) async {
    try {
      final medicine = await remoteDataSource.getMedicineById(id: id);

      return Right(medicine);
    } on ServerException catch (e) {
      throw Left(Failure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Medication>>> getAllMedications() async {
    try {
      final allMedications = await remoteDataSource.getAllMedications();

      return Right(allMedications);
    } on ServerException catch (e) {
      throw Left(Failure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleMedicationStatusById({required String id, DateTime? timeTaken}) async {
    try {
      await remoteDataSource.toggleMedicationStatusById(id: id, timeTaken: timeTaken);

      return Right(null);
    } on ServerException catch (e) {
      throw Left(Failure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addAssignedMedication(AssignedMedicationReport assignedMedication) async {
    try {
      final medicationModel = AssignedMedicationReportModel(
        id: assignedMedication.id,
        assignedTo: assignedMedication.assignedTo,
        assignedBy: assignedMedication.assignedBy,
        medicines:
            assignedMedication.medicines
                .map((medicineSchedule) => MedicineScheduleModel.fromEntity(medicineSchedule))
                .toList(),
        startDate: assignedMedication.startDate,
        endDate: assignedMedication.endDate,
      );

      await remoteDataSource.addAssignedMedication(medicationModel);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
