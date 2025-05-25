import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_medications_controller.dart';
import 'package:healthyways/core/common/controllers/app_patient_controller.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:healthyways/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:healthyways/features/auth/domain/repositories/auth_repository.dart';
import 'package:healthyways/features/auth/domain/usecases/current_profile.dart';
import 'package:healthyways/features/auth/domain/usecases/user_sign_in.dart';
import 'package:healthyways/features/auth/domain/usecases/user_sign_out.dart';
import 'package:healthyways/features/auth/domain/usecases/user_sign_up.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';
import 'package:healthyways/features/doctor/data/datasources/doctor_remote_data_source.dart';
import 'package:healthyways/features/doctor/data/repositories/doctor_repository_impl.dart';
import 'package:healthyways/features/doctor/domain/repositories/doctor_repository.dart';
import 'package:healthyways/features/doctor/domain/usecases/get_all_doctors.dart';
import 'package:healthyways/features/doctor/domain/usecases/get_doctor_by_id.dart';
import 'package:healthyways/features/doctor/domain/usecases/update_doctor_profile.dart';
import 'package:healthyways/features/doctor/presentation/controllers/doctor_controller.dart';
import 'package:healthyways/features/medication/data/datasources/dummy_remote_data_source_impl.dart';
import 'package:healthyways/features/medication/data/datasources/medications_remote_data_source.dart';
import 'package:healthyways/features/medication/data/repositories/medication_repository_impl.dart';
import 'package:healthyways/features/medication/domain/repositories/medication_repository.dart';
import 'package:healthyways/features/medication/domain/usecases/get_all_medications.dart';
import 'package:healthyways/features/medication/domain/usecases/get_all_medicines.dart';
import 'package:healthyways/features/medication/domain/usecases/toggle_medication_status_by_id.dart';
import 'package:healthyways/features/medication/presentation/controllers/medication_controller.dart';
import 'package:healthyways/features/patient/data/datasources/patient_remote_data_source.dart';
import 'package:healthyways/features/patient/data/repositories/patient_repository_impl.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';
import 'package:healthyways/features/patient/domain/usecases/get_all_patients.dart';
import 'package:healthyways/features/patient/domain/usecases/get_patient_by_id.dart';
import 'package:healthyways/features/patient/domain/usecases/update_patient_profile.dart';
import 'package:healthyways/features/patient/presentation/controllers/patient_controller.dart';
import 'package:healthyways/features/pharmacist/data/datasources/pharmacist_remote_data_source.dart';
import 'package:healthyways/features/pharmacist/data/repositores/pharmacist_profile_repository_impl.dart';
import 'package:healthyways/features/pharmacist/domain/repositories/pharmacist_repository.dart';
import 'package:healthyways/features/pharmacist/domain/usecases/get_all_pharmacists.dart';
import 'package:healthyways/features/pharmacist/domain/usecases/get_pharmacist_by_id.dart';
import 'package:healthyways/features/pharmacist/domain/usecases/update_pharmacist_profile.dart';
import 'package:healthyways/features/pharmacist/presentation/controllers/pharmacist_controller.dart';
import 'package:healthyways/features/updates/data/datasources/i_updates_remote_data_source.dart';
import 'package:healthyways/features/updates/data/datasources/updates_dummy_data_source.dart';
import 'package:healthyways/features/updates/data/repositories/updates_repository_impl.dart';
import 'package:healthyways/features/updates/domain/repositories/updates_repository.dart';
import 'package:healthyways/features/updates/domain/usecases/get_all_medication_schedule_report.dart';
import 'package:healthyways/features/updates/presentation/controllers/updates_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize dependencies here

  await dotenv.load(fileName: ".env");

  final supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  serviceLocator.registerSingleton<SupabaseClient>(supabase.client);

  //TODO: remove after adding valid datasource
  Get.lazyPut<DummyMedicationSource>(() => DummyMedicationSource());
  Get.lazyPut<UpdatesDummyController>(() => UpdatesDummyController());

  // Initialize feature-specific dependencies
  _initAuth();
  _initPatient();
  _initMedications();
  _initUpdates();
  // _initDoctor();
  // _initPharmacist();
}

void _initAuth() {
  // Data sources
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
  );

  // Repositories
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator<AuthRemoteDataSource>()),
  );

  // Use cases
  serviceLocator
    ..registerFactory<UserSignIn>(
      () => UserSignIn(serviceLocator<AuthRepository>()),
    )
    ..registerFactory<UserSignUp>(
      () => UserSignUp(serviceLocator<AuthRepository>()),
    )
    ..registerFactory<UserSignOut>(
      () => UserSignOut(serviceLocator<AuthRepository>()),
    )
    ..registerFactory<CurrentProfile>(
      () => CurrentProfile(serviceLocator<AuthRepository>()),
    );

  // App level controller
  serviceLocator.registerLazySingleton(() => AppProfileController());

  // Controller
  serviceLocator.registerSingleton<AuthController>(
    AuthController(
      currentProfile: serviceLocator<CurrentProfile>(),
      userSignup: serviceLocator<UserSignUp>(),
      userSignIn: serviceLocator<UserSignIn>(),
      userSignOut: serviceLocator<UserSignOut>(),
      appProfileController: serviceLocator<AppProfileController>(),
    ),
  );
}

void _initPatient() {
  // Data sources
  serviceLocator.registerFactory<PatientRemoteDataSource>(
    () => PatientRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
  );

  // Repositories
  serviceLocator.registerFactory<PatientRepository>(
    () => PatientRepositoryImpl(serviceLocator<PatientRemoteDataSource>()),
  );

  // Use cases
  serviceLocator
    ..registerFactory<GetAllPatients>(
      () => GetAllPatients(serviceLocator<PatientRepository>()),
    )
    ..registerFactory<GetPatientById>(
      () => GetPatientById(serviceLocator<PatientRepository>()),
    )
    ..registerFactory<UpdatePatientProfile>(
      () => UpdatePatientProfile(serviceLocator<PatientRepository>()),
    );

  // Controller
  serviceLocator.registerSingleton<PatientController>(
    PatientController(
      getAllPatients: serviceLocator<GetAllPatients>(),
      getPatientById: serviceLocator<GetPatientById>(),
      updatePatientProfile: serviceLocator<UpdatePatientProfile>(),
    ),
  );

  // App-level controller
  serviceLocator.registerSingleton<AppPatientController>(
    AppPatientController(
      patientController: serviceLocator<PatientController>(),
    ),
  );
}

void _initMedications() {
  // Data sources
  serviceLocator.registerFactory<MedicationsRemoteDataSource>(
    () => MedicationsDummyRemoteDataSourceImpl(),
    //TODO: replace with actual Datasource
  );

  // Repositories
  serviceLocator.registerFactory<MedicationRepository>(
    () =>
        MedicationRepositoryImpl(serviceLocator<MedicationsRemoteDataSource>()),
  );

  // Use cases
  serviceLocator
    ..registerFactory<GetAllMedicines>(
      () => GetAllMedicines(serviceLocator<MedicationRepository>()),
    )
    ..registerFactory<GetAllMedications>(
      () => GetAllMedications(serviceLocator<MedicationRepository>()),
    )
    ..registerFactory<ToggleMedicationStatusById>(
      () => ToggleMedicationStatusById(serviceLocator<MedicationRepository>()),
    );

  // App-level controller
  serviceLocator.registerSingleton(() => AppMedicationsController());

  // Controller
  serviceLocator.registerSingleton<MedicationController>(
    MedicationController(
      getAllMedicines: serviceLocator<GetAllMedicines>(),
      getAllMedications: serviceLocator<GetAllMedications>(),
      toggleMedicationStatusById: serviceLocator<ToggleMedicationStatusById>(),
    ),
  );
}

void _initUpdates() {
  // Data sources
  serviceLocator.registerFactory<IUpdatesRemoteDataSource>(
    () => UpdatesDummyDataSource(),
    //TODO: replace with actual Datasource
  );

  // Repositories
  serviceLocator.registerFactory<UpdatesRepository>(
    () => UpdatesRepositoryImpl(serviceLocator<IUpdatesRemoteDataSource>()),
  );

  // Use cases
  serviceLocator.registerFactory<GetAllMedicationScheduleReport>(
    () => GetAllMedicationScheduleReport(serviceLocator<UpdatesRepository>()),
  );

  // // App-level controller
  // serviceLocator.registerSingleton(() => AppMedicationsController());

  // Controller
  serviceLocator.registerSingleton<UpdatesController>(
    UpdatesController(
      getAllMedicationScheduleReport:
          serviceLocator<GetAllMedicationScheduleReport>(),
    ),
  );
}

void _initDoctor() {
  // Data sources
  serviceLocator.registerFactory<DoctorRemoteDataSource>(
    () => DoctorRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
  );

  // Repositories
  serviceLocator.registerFactory<DoctorRepository>(
    () => DoctorRepositoryImpl(serviceLocator<DoctorRemoteDataSource>()),
  );

  // Use cases
  serviceLocator
    ..registerFactory<GetAllDoctors>(
      () => GetAllDoctors(serviceLocator<DoctorRepository>()),
    )
    ..registerFactory<GetDoctorById>(
      () => GetDoctorById(serviceLocator<DoctorRepository>()),
    )
    ..registerFactory<UpdateDoctorProfile>(
      () => UpdateDoctorProfile(serviceLocator<DoctorRepository>()),
    );

  // Controller
  serviceLocator.registerSingleton<DoctorController>(
    DoctorController(
      getAllDoctors: serviceLocator<GetAllDoctors>(),
      getDoctorById: serviceLocator<GetDoctorById>(),
      updateDoctorProfile: serviceLocator<UpdateDoctorProfile>(),
    ),
  );
}

void _initPharmacist() {
  // Data sources
  serviceLocator.registerFactory<PharmacistRemoteDataSource>(
    () => PharmacistRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
  );

  // Repositories
  serviceLocator.registerFactory<PharmacistRepository>(
    () =>
        PharmacistRepositoryImpl(serviceLocator<PharmacistRemoteDataSource>()),
  );

  // Use cases
  serviceLocator
    ..registerFactory<GetAllPharmacists>(
      () => GetAllPharmacists(serviceLocator<PharmacistRepository>()),
    )
    ..registerFactory<GetPharmacistById>(
      () => GetPharmacistById(serviceLocator<PharmacistRepository>()),
    )
    ..registerFactory<UpdatePharmacistProfile>(
      () => UpdatePharmacistProfile(serviceLocator<PharmacistRepository>()),
    );

  // Controller
  serviceLocator.registerSingleton<PharmacistController>(
    PharmacistController(
      getAllPharmacists: serviceLocator<GetAllPharmacists>(),
      getPharmacistById: serviceLocator<GetPharmacistById>(),
      updatePharmacistProfile: serviceLocator<UpdatePharmacistProfile>(),
    ),
  );
}
