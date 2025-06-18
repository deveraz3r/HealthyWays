import 'package:healthyways/core/common/custom_types/shape.dart';
import 'package:healthyways/core/constants/supabase/supabase_tables.dart';
import 'package:healthyways/features/medication/data/datasources/medications_remote_data_source.dart';
import 'package:healthyways/core/common/models/assigned_medication_model.dart' show AssignedMedicationReportModel;
import 'package:healthyways/features/medication/data/models/medication_model.dart';
import 'package:healthyways/features/medication/data/models/medicine_model.dart';
import 'package:healthyways/core/common/models/medicine_schedule_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicationsRemoteDataSourceImpl implements MedicationsRemoteDataSource {
  final SupabaseClient client;

  MedicationsRemoteDataSourceImpl(this.client);

  @override
  Future<List<MedicineModel>> getAllMedicines() async {
    try {
      final response = await client.from(SupabaseTables.medicinesTable).select();

      final List data = response as List;
      return data.map((json) => MedicineModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch medicines: $e');
    }
  }

  @override
  Future<MedicineModel> getMedicineById({required String id}) async {
    try {
      final response = await client.from(SupabaseTables.medicinesTable).select().eq("id", id).single();

      return MedicineModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch medicines: $e');
    }
  }

  @override
  Future<List<MedicationModel>> getAllMedications() async {
    try {
      final response = await client.from(SupabaseTables.medicationsTable).select();

      final List data = response as List;
      return data.map((json) => MedicationModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch medications: $e');
    }
  }

  @override
  Future<void> toggleMedicationStatusById({required String id, DateTime? timeTaken}) async {
    try {
      // Fetch current status
      final response = await client.from('medications').select('isTaken').eq('id', id).single();

      final currentIsTaken = response['isTaken'] as bool;

      final newIsTaken = !currentIsTaken;
      final newTakenTime = newIsTaken ? (timeTaken ?? DateTime.now()) : null;

      await client
          .from('medications')
          .update({'isTaken': newIsTaken, 'takenTime': newTakenTime?.toIso8601String()})
          .eq('id', id);

      print('Medication $id updated: isTaken = $newIsTaken');
    } catch (e) {
      print('Failed to toggle medication status: $e');
      rethrow;
    }
  }

  @override
  Future<void> addAssignedMedication(AssignedMedicationReportModel assignedMedication) async {
    try {
      // Create a copy of JSON and remove the 'medicines' key
      final assignedMedicationJson = Map<String, dynamic>.from(assignedMedication.toJson())..remove('medicines');

      // 1. Insert into assignedMedications table (without 'medicines')
      await client.from(SupabaseTables.assignedMedications).insert(assignedMedicationJson);

      // 2. Insert each medicineSchedule into medicineSchedules table
      for (final schedule in assignedMedication.medicines.cast<MedicineScheduleModel>()) {
        final medicineScheduleJson = schedule.toJson()..['assignedMedicationId'] = assignedMedication.id;

        await client.from(SupabaseTables.medicineSchedules).insert(medicineScheduleJson);
      }
    } catch (e) {
      throw Exception('Failed to add assigned medication: $e');
    }
  }
}
