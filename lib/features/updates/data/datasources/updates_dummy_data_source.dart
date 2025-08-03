import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/common/entites/assigned_medication_report.dart';
import 'package:healthyways/core/common/models/assigned_medication_model.dart';
import 'package:healthyways/core/common/models/medicine_schedule_model.dart';
import 'package:healthyways/core/constants/supabase/supabase_tables.dart';
import 'package:healthyways/features/updates/data/datasources/i_updates_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdatesRemoteDataSourceImpl implements IUpdatesRemoteDataSource {
  final SupabaseClient client;

  UpdatesRemoteDataSourceImpl(this.client);

  @override
  Future<List<AssignedMedicationReport>> getAllMedicationScheduleReport({
    required String uid,
    required Role role,
  }) async {
    try {
      String associatedCol;

      switch (role) {
        case Role.doctor:
        case Role.pharmacist:
          associatedCol = "assignedBy";
          break;
        case Role.patient:
          associatedCol = "assignedTo";
          break;
      }

      // Step 1: Get all assigned medications
      final assignedResponse = await client
          .from(SupabaseTables.assignedMedications)
          .select()
          .eq(associatedCol, uid)
          .order('startDate', ascending: false);

      final assignedMedications = List<Map<String, dynamic>>.from(
        assignedResponse,
      );

      // Step 2: For each assigned medication, fetch its medicine schedules
      List<AssignedMedicationReportModel> results = [];

      for (final med in assignedMedications) {
        final assignedId = med['id'] as String;

        // Fetch related medicineSchedules
        final medicineSchedulesResponse = await client
            .from(SupabaseTables.medicineSchedules)
            .select()
            .eq('assignedMedicationId', assignedId);

        final medicineSchedules = List<Map<String, dynamic>>.from(
          medicineSchedulesResponse,
        );

        // Parse the medicine schedules
        final schedules =
            medicineSchedules
                .map((json) => MedicineScheduleModel.fromJson(json))
                .toList();

        // Build the report
        final report = AssignedMedicationReportModel(
          id: assignedId,
          assignedTo: med['assignedTo'],
          assignedBy: med['assignedBy'],
          startDate: DateTime.parse(med['startDate']),
          endDate: DateTime.parse(med['endDate']),
          medicines: schedules,
        );

        results.add(report);
      }

      return results;
    } catch (e) {
      throw Exception('Failed to fetch medication schedule reports: $e');
    }
  }
}
