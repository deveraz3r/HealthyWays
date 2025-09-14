// import 'package:fpdart/fpdart.dart';
// import 'package:healthyways/core/error/failure.dart';
// import 'package:healthyways/core/usecase/usecase.dart';
// import 'package:healthyways/features/doctor/domain/repositories/doctor_repository.dart';

// class AddMyPatient implements UseCase<void, AddMyPatientParams> {
//   final DoctorRepository repository;
//   AddMyPatient(this.repository);

//   @override
//   Future<Either<Failure, void>> call(AddMyPatientParams params) async {
//     return await repository.addMyPatient(params.patientId);
//   }
// }

// class AddMyPatientParams {
//   final String patientId;
//   AddMyPatientParams({required this.patientId});
// }
