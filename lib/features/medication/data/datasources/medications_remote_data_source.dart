import 'package:healthyways/features/medication/data/models/medication_model.dart';
import 'package:healthyways/features/medication/data/models/medicine_model.dart';

abstract interface class MedicationsRemoteDataSource {
  Future<List<MedicineModel>> getAllMedicines();
  Future<List<MedicationModel>> getAllMedications();
  Future<void> toggleMedicationStatusById({
    required String id,
    DateTime? timeTaken,
  });
}
