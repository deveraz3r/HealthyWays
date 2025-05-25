import 'package:get/get.dart';
import 'package:healthyways/core/common/entites/medicine.dart';
import 'package:healthyways/core/controller/controller_state_manager.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/common/entites/medication.dart';

class AppMedicationsController extends GetxController {
  final allMedicines = StateController<Failure, List<Medicine>>();
  final allMedications = StateController<Failure, List<Medication>>();
}
