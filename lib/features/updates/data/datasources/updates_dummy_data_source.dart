import 'package:get/get.dart';
import 'package:healthyways/core/common/custom_types/shape.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/features/updates/data/datasources/i_updates_remote_data_source.dart';
import 'package:healthyways/features/updates/data/models/medication_schedule_report_model.dart';

class UpdatesDummyDataSource implements IUpdatesRemoteDataSource {
  @override
  Future<List<MedicationScheduleReportModel>>
  getAllMedicationScheduleReport() async {
    return Get.find<UpdatesDummyController>().dummyMedicationScheduleReports;
  }
}

class UpdatesDummyController extends GetxController {
  final RxList<MedicationScheduleReportModel> dummyMedicationScheduleReports =
      <MedicationScheduleReportModel>[
        MedicationScheduleReportModel(
          id: '1',
          medicine: Medicine(
            id: 'med1',
            name: 'Paracetamol',
            dosage: 500,
            unit: 'mg',
            shape: Shape(
              image: 'assets/images/tablet.png',
              primaryColorHex: '#FF5733',
              secondryColorHex: '#FFC300',
            ),
          ),
          assignedTo: 'patient123',
          assignedBy: 'doctor456',
          assignerRole: 'Physician',
          quantity: 30,
          frequency: 'Every 6 hours',
          endTime: DateTime.now().add(const Duration(days: 30)),
          isActive: true,
        ),
        MedicationScheduleReportModel(
          id: '2',
          medicine: Medicine(
            id: 'med2',
            name: 'Ibuprofen',
            dosage: 200,
            unit: 'mg',
            shape: Shape(
              image: 'assets/images/capsule.png',
              primaryColorHex: '#33A2FF',
              secondryColorHex: '#33FF57',
            ),
          ),
          assignedTo: 'patient123',
          assignedBy: 'nurse789',
          assignerRole: 'Nurse',
          quantity: 20,
          frequency: 'Every 8 hours',
          endTime: DateTime.now().add(const Duration(days: 14)),
          isActive: true,
        ),
        MedicationScheduleReportModel(
          id: '3',
          medicine: Medicine(
            id: 'med3',
            name: 'Amoxicillin',
            dosage: 250,
            unit: 'mg',
            shape: Shape(
              image: 'assets/images/capsule.png',
              primaryColorHex: '#8A33FF',
              secondryColorHex: null, // No secondary color for this one
            ),
          ),
          assignedTo: 'patient456',
          assignedBy: 'doctor123',
          assignerRole: 'Pediatrician',
          quantity: 40,
          frequency: 'Twice daily',
          endTime: DateTime.now().add(const Duration(days: 10)),
          isActive: false,
        ),
        MedicationScheduleReportModel(
          id: '4',
          medicine: Medicine(
            id: 'med4',
            name: 'Lisinopril',
            dosage: 10,
            unit: 'mg',
            shape: Shape(
              image: 'assets/images/tablet.png',
              primaryColorHex: '#FF33A2',
              secondryColorHex: '#33FFF5',
            ),
          ),
          assignedTo: 'patient789',
          assignedBy: 'doctor456',
          assignerRole: 'Cardiologist',
          quantity: 90,
          frequency: 'Once daily',
          endTime: DateTime.now().add(const Duration(days: 90)),
          isActive: true,
        ),
      ].obs;
}
