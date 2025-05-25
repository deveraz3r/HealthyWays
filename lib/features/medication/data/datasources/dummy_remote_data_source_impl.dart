import 'package:get/get.dart';
import 'package:healthyways/core/common/custom_types/shape.dart';
import 'package:healthyways/features/medication/data/datasources/medications_remote_data_source.dart';
import 'package:healthyways/features/medication/data/models/medication_model.dart';
import 'package:healthyways/features/medication/data/models/medicine_model.dart';

class MedicationsDummyRemoteDataSourceImpl
    implements MedicationsRemoteDataSource {
  final controller = Get.find<DummyMedicationSource>();

  @override
  Future<List<MedicineModel>> getAllMedicines() async {
    return controller.dummyMedicines;
  }

  @override
  Future<List<MedicationModel>> getAllMedications() async {
    return controller.dummyMedications;
  }

  @override
  Future<void> toggleMedicationStatusById({
    required String id,
    DateTime? timeTaken,
  }) async {
    final index = controller.dummyMedications.indexWhere((e) => e.id == id);

    if (index != -1) {
      final current = controller.dummyMedications[index];
      controller.dummyMedications[index] = current.copyWith(
        isTaken: !current.isTaken,
        takenTime: !current.isTaken ? (timeTaken ?? DateTime.now()) : null,
      );
    }

    print(controller.dummyMedications[index]);
  }
}

class DummyMedicationSource extends GetxController {
  RxList<MedicineModel> dummyMedicines =
      [
        MedicineModel(
          id: 'med1',
          name: 'Paracetamol',
          dosage: 500,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/round_pill.svg',
            primaryColorHex: '#FFFFFF',
            secondryColorHex: null,
          ),
        ),
        MedicineModel(
          id: 'med2',
          name: 'Ibuprofen',
          dosage: 200,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/capsule.svg',
            primaryColorHex: '#FF5733',
            secondryColorHex: '#FFC300',
          ),
        ),
        MedicineModel(
          id: 'med3',
          name: 'Aspirin',
          dosage: 100,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/round_pill.svg',
            primaryColorHex: '#E0E0E0',
            secondryColorHex: null,
          ),
        ),
        MedicineModel(
          id: 'med4',
          name: 'Amoxicillin',
          dosage: 250,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/capsule.svg',
            primaryColorHex: '#E74C3C',
            secondryColorHex: '#F39C12',
          ),
        ),
        MedicineModel(
          id: 'med5',
          name: 'Vitamin C',
          dosage: 1000,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/round_pill.svg',
            primaryColorHex: '#F1C40F',
            secondryColorHex: null,
          ),
        ),
        MedicineModel(
          id: 'med6',
          name: 'Metformin',
          dosage: 500,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/capsule.svg',
            primaryColorHex: '#8E44AD',
            secondryColorHex: '#3498DB',
          ),
        ),
        MedicineModel(
          id: 'med7',
          name: 'Loratadine',
          dosage: 10,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/round_pill.svg',
            primaryColorHex: '#2ECC71',
            secondryColorHex: null,
          ),
        ),
        MedicineModel(
          id: 'med8',
          name: 'Doxycycline',
          dosage: 100,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/capsule.svg',
            primaryColorHex: '#1ABC9C',
            secondryColorHex: '#16A085',
          ),
        ),
        MedicineModel(
          id: 'med9',
          name: 'Cetirizine',
          dosage: 5,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/round_pill.svg',
            primaryColorHex: '#AAB7B8',
            secondryColorHex: null,
          ),
        ),
        MedicineModel(
          id: 'med10',
          name: 'Naproxen',
          dosage: 250,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/capsule.svg',
            primaryColorHex: '#F1948A',
            secondryColorHex: '#D98880',
          ),
        ),
        MedicineModel(
          id: 'med11',
          name: 'Azithromycin',
          dosage: 500,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/capsule.svg',
            primaryColorHex: '#5D6D7E',
            secondryColorHex: '#85929E',
          ),
        ),
        MedicineModel(
          id: 'med12',
          name: 'Prednisone',
          dosage: 20,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/round_pill.svg',
            primaryColorHex: '#FAD7A0',
            secondryColorHex: null,
          ),
        ),
        MedicineModel(
          id: 'med13',
          name: 'Simvastatin',
          dosage: 40,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/capsule.svg',
            primaryColorHex: '#7FB3D5',
            secondryColorHex: '#2980B9',
          ),
        ),
        MedicineModel(
          id: 'med14',
          name: 'Levothyroxine',
          dosage: 75,
          unit: 'mcg',
          shape: Shape(
            image: 'assets/images/round_pill.svg',
            primaryColorHex: '#F5CBA7',
            secondryColorHex: null,
          ),
        ),
        MedicineModel(
          id: 'med15',
          name: 'Clindamycin',
          dosage: 300,
          unit: 'mg',
          shape: Shape(
            image: 'assets/images/capsule.svg',
            primaryColorHex: '#AF7AC5',
            secondryColorHex: '#BB8FCE',
          ),
        ),
      ].obs;

  RxList<MedicationModel> dummyMedications =
      [
        // Today's medications (2025-05-25)

        // Morning (3 items) - 2 doctor assigned, 1 self-assigned
        MedicationModel(
          id: "med-100",
          medicine: MedicineModel(
            id: "medic-100",
            name: "Paracetamol",
            dosage: 500,
            unit: "mg",
            shape: Shape(
              image: "capsule.png",
              primaryColorHex: "#123456",
              secondryColorHex: "#654321",
            ),
          ),
          assignedTo: "patient-789",
          assignedBy: "doctor-123",
          doctorFName: "Dr. Smith",
          doctorImageUrl: "https://example.com/dr-smith.jpg",
          isActive: true,
          quantity: 10,
          allocatedTime: DateTime(2025, 5, 25, 8, 0),
          isTaken: true,
          takenTime: DateTime(2025, 5, 25, 8, 15),
        ),
        MedicationModel(
          id: "med-101",
          medicine: MedicineModel(
            id: "medic-101",
            name: "Multivitamin",
            dosage: 1,
            unit: "tablet",
            shape: Shape(
              image: "pill.png",
              primaryColorHex: "#FF5733",
              secondryColorHex: null,
            ),
          ),
          assignedTo: "patient-789",
          assignedBy: "doctor-456",
          doctorFName: "Dr. Johnson",
          doctorImageUrl: "https://example.com/dr-johnson.jpg",
          isActive: true,
          quantity: 30,
          allocatedTime: DateTime(2025, 5, 25, 9, 0),
          isTaken: false,
        ),
        MedicationModel(
          id: "med-102",
          medicine: MedicineModel(
            id: "medic-102",
            name: "Vitamin C",
            dosage: 250,
            unit: "mg",
            shape: Shape(
              image: "tablet.png",
              primaryColorHex: "#FFFFFF",
              secondryColorHex: "#FF0000",
            ),
          ),
          assignedTo: "patient-789",
          assignedBy: null, // Self-assigned
          doctorFName: null,
          doctorImageUrl: null,
          isActive: true,
          quantity: 20,
          allocatedTime: DateTime(2025, 5, 25, 10, 0),
          isTaken: false,
        ),

        // Afternoon (3 items) - 1 doctor assigned, 2 self-assigned
        MedicationModel(
          id: "med-103",
          medicine: MedicineModel(
            id: "medic-103",
            name: "Ibuprofen",
            dosage: 400,
            unit: "mg",
            shape: Shape(
              image: "capsule.png",
              primaryColorHex: "#0000FF",
              secondryColorHex: "#FFFFFF",
            ),
          ),
          assignedTo: "patient-789",
          assignedBy: "doctor-123",
          doctorFName: "Dr. Smith",
          doctorImageUrl: "https://example.com/dr-smith.jpg",
          isActive: true,
          quantity: 15,
          allocatedTime: DateTime(2025, 5, 25, 13, 0),
          isTaken: true,
          takenTime: DateTime(2025, 5, 25, 13, 30),
        ),
        MedicationModel(
          id: "med-104",
          medicine: MedicineModel(
            id: "medic-104",
            name: "Probiotic",
            dosage: 1,
            unit: "capsule",
            shape: Shape(
              image: "capsule.png",
              primaryColorHex: "#FF00FF",
              secondryColorHex: "#00FF00",
            ),
          ),
          assignedTo: "patient-789",
          assignedBy: null, // Self-assigned
          doctorFName: null,
          doctorImageUrl: null,
          isActive: true,
          quantity: 14,
          allocatedTime: DateTime(2025, 5, 25, 14, 30),
          isTaken: false,
        ),
        MedicationModel(
          id: "med-105",
          medicine: MedicineModel(
            id: "medic-105",
            name: "Fish Oil",
            dosage: 1000,
            unit: "mg",
            shape: Shape(
              image: "capsule.png",
              primaryColorHex: "#FFA500",
              secondryColorHex: null,
            ),
          ),
          assignedTo: "patient-789",
          assignedBy: null, // Self-assigned
          doctorFName: null,
          doctorImageUrl: null,
          isActive: true,
          quantity: 60,
          allocatedTime: DateTime(2025, 5, 25, 16, 0),
          isTaken: false,
        ),

        // Evening (3 items) - 2 doctor assigned, 1 self-assigned
        MedicationModel(
          id: "med-106",
          medicine: MedicineModel(
            id: "medic-106",
            name: "Antihistamine",
            dosage: 10,
            unit: "mg",
            shape: Shape(
              image: "pill.png",
              primaryColorHex: "#00FF00",
              secondryColorHex: "#0000FF",
            ),
          ),
          assignedTo: "patient-789",
          assignedBy: "doctor-789",
          doctorFName: "Dr. Williams",
          doctorImageUrl: "https://example.com/dr-williams.jpg",
          isActive: true,
          quantity: 30,
          allocatedTime: DateTime(2025, 5, 25, 18, 0),
          isTaken: false,
        ),
        MedicationModel(
          id: "med-107",
          medicine: MedicineModel(
            id: "medic-107",
            name: "Calcium",
            dosage: 600,
            unit: "mg",
            shape: Shape(
              image: "tablet.png",
              primaryColorHex: "#FFFFFF",
              secondryColorHex: "#000000",
            ),
          ),
          assignedTo: "patient-789",
          assignedBy: "doctor-123",
          doctorFName: "Dr. Smith",
          doctorImageUrl: "https://example.com/dr-smith.jpg",
          isActive: true,
          quantity: 90,
          allocatedTime: DateTime(2025, 5, 25, 19, 30),
          isTaken: false,
        ),
        MedicationModel(
          id: "med-108",
          medicine: MedicineModel(
            id: "medic-108",
            name: "Melatonin",
            dosage: 5,
            unit: "mg",
            shape: Shape(
              image: "tablet.png",
              primaryColorHex: "#000000",
              secondryColorHex: "#FFFFFF",
            ),
          ),
          assignedTo: "patient-789",
          assignedBy: null, // Self-assigned
          doctorFName: null,
          doctorImageUrl: null,
          isActive: true,
          quantity: 30,
          allocatedTime: DateTime(2025, 5, 25, 20, 45),
          isTaken: false,
        ),

        // Night (3 items) - 1 doctor assigned, 2 self-assigned
        MedicationModel(
          id: "med-109",
          medicine: MedicineModel(
            id: "medic-109",
            name: "Sleep Aid",
            dosage: 25,
            unit: "mg",
            shape: Shape(
              image: "capsule.png",
              primaryColorHex: "#800080",
              secondryColorHex: "#FFD700",
            ),
          ),
          assignedTo: "patient-789",
          assignedBy: "doctor-456",
          doctorFName: "Dr. Johnson",
          doctorImageUrl: "https://example.com/dr-johnson.jpg",
          isActive: true,
          quantity: 15,
          allocatedTime: DateTime(2025, 5, 25, 22, 0),
          isTaken: false,
        ),
        MedicationModel(
          id: "med-110",
          medicine: MedicineModel(
            id: "medic-110",
            name: "Magnesium",
            dosage: 250,
            unit: "mg",
            shape: Shape(
              image: "tablet.png",
              primaryColorHex: "#FF6347",
              secondryColorHex: null,
            ),
          ),
          assignedTo: "patient-789",
          assignedBy: null, // Self-assigned
          doctorFName: null,
          doctorImageUrl: null,
          isActive: true,
          quantity: 60,
          allocatedTime: DateTime(2025, 5, 25, 23, 30),
          isTaken: false,
        ),
        MedicationModel(
          id: "med-111",
          medicine: MedicineModel(
            id: "medic-111",
            name: "Pain Reliever",
            dosage: 200,
            unit: "mg",
            shape: Shape(
              image: "pill.png",
              primaryColorHex: "#FF0000",
              secondryColorHex: "#FFFFFF",
            ),
          ),
          assignedTo: "patient-789",
          assignedBy: null, // Self-assigned
          doctorFName: null,
          doctorImageUrl: null,
          isActive: true,
          quantity: 10,
          allocatedTime: DateTime(
            2025,
            5,
            25,
            4,
            0,
          ), // Early morning (night slot)
          isTaken: false,
        ),

        // Tomorrow's medications (2025-05-26) - similar pattern
        MedicationModel(
          id: "med-112",
          medicine: MedicineModel(
            id: "medic-112",
            name: "Blood Pressure Med",
            dosage: 50,
            unit: "mg",
            shape: Shape(
              image: "pill.png",
              primaryColorHex: "#123456",
              secondryColorHex: "#654321",
            ),
          ),
          assignedTo: "patient-789",
          assignedBy: "doctor-123",
          doctorFName: "Dr. Smith",
          doctorImageUrl: "https://example.com/dr-smith.jpg",
          isActive: true,
          quantity: 30,
          allocatedTime: DateTime(2025, 5, 26, 8, 0),
          isTaken: false,
        ),
        // Add more tomorrow's medications following the same pattern...
      ].obs;
}
