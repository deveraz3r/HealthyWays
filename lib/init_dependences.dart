import 'package:healthyways/core/common/controllers/app_medications_controller.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/features/allergies/data/datasources/allergies_remote_data_source.dart';
import 'package:healthyways/features/allergies/data/repositories/allergie_repository_impl.dart';
import 'package:healthyways/features/allergies/domain/repositories/allergie_repository.dart';
import 'package:healthyways/features/allergies/domain/usecases/create_allergie_entry.dart';
import 'package:healthyways/features/allergies/domain/usecases/delete_allergie_entry.dart';
import 'package:healthyways/features/allergies/domain/usecases/get_all_allergie_entries.dart';
import 'package:healthyways/features/allergies/domain/usecases/update_allergie_entry.dart';
import 'package:healthyways/features/allergies/presentation/controllers/allergie_controller.dart';
import 'package:healthyways/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:healthyways/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:healthyways/features/auth/domain/repositories/auth_repository.dart';
import 'package:healthyways/features/auth/domain/usecases/current_profile.dart';
import 'package:healthyways/features/auth/domain/usecases/user_sign_in.dart';
import 'package:healthyways/features/auth/domain/usecases/user_sign_out.dart';
import 'package:healthyways/features/auth/domain/usecases/user_sign_up.dart';
import 'package:healthyways/features/auth/presentation/controller/auth_controller.dart';
import 'package:healthyways/features/diary/data/datasources/diary_remote_data_source.dart';
import 'package:healthyways/features/diary/data/repositories/diary_repository_impl.dart';
import 'package:healthyways/features/diary/domain/repositories/diary_repository.dart';
import 'package:healthyways/features/diary/domain/usecases/create_diary_entry.dart';
import 'package:healthyways/features/diary/domain/usecases/delete_diary_entry.dart';
import 'package:healthyways/features/diary/domain/usecases/get_all_diary_entries.dart';
import 'package:healthyways/features/diary/domain/usecases/update_diary_entry.dart';
import 'package:healthyways/features/diary/presentation/controllers/diary_controller.dart';
import 'package:healthyways/features/doctor/data/datasources/doctor_remote_data_source.dart';
import 'package:healthyways/features/doctor/data/repositories/doctor_repository_impl.dart';
import 'package:healthyways/features/doctor/domain/repositories/doctor_repository.dart';
import 'package:healthyways/features/doctor/domain/usecases/get_all_doctors.dart';
import 'package:healthyways/features/doctor/domain/usecases/get_doctor_by_id.dart';
import 'package:healthyways/features/doctor/domain/usecases/update_doctor_profile.dart';
import 'package:healthyways/features/doctor/presentation/controllers/doctor_controller.dart';
import 'package:healthyways/features/immunization/data/datasources/immunization_remote_data_source.dart';
import 'package:healthyways/features/immunization/data/repositories/immunization_repository_impl.dart';
import 'package:healthyways/features/immunization/domain/usecases/create_immunization_entry.dart';
import 'package:healthyways/features/immunization/domain/usecases/delete_immunization_entry.dart';
import 'package:healthyways/features/immunization/domain/usecases/get_all_immunization_entries.dart';
import 'package:healthyways/features/immunization/domain/usecases/update_immunization_entry.dart';
import 'package:healthyways/features/immunization/presentation/controllers/immunization_controller.dart';
import 'package:healthyways/features/measurements/data/datasources/measurement_remote_data_source.dart';
import 'package:healthyways/features/measurements/data/repositories/measurement_repository_impl.dart';
import 'package:healthyways/features/measurements/domain/repositories/measurement_repository.dart';
import 'package:healthyways/features/measurements/domain/usecases/add_measurement_entry.dart';
import 'package:healthyways/features/patient/domain/usecases/add_measurement_entry.dart' as patient;
import 'package:healthyways/features/measurements/domain/usecases/get_all_measurements.dart';
import 'package:healthyways/features/measurements/domain/usecases/get_measurement_entries.dart';
import 'package:healthyways/features/measurements/domain/usecases/get_measurement_visibility.dart';
import 'package:healthyways/features/measurements/domain/usecases/get_my_measurement.dart';
import 'package:healthyways/features/measurements/domain/usecases/toggle_my_measurement_status.dart';
import 'package:healthyways/features/measurements/domain/usecases/update_measurement_visibility.dart';
import 'package:healthyways/features/measurements/domain/usecases/update_my_measurement_reminder_settings.dart';
import 'package:healthyways/features/measurements/presentation/controllers/measurement_controller.dart';
import 'package:healthyways/features/medication/data/datasources/medications_remote_data_source_impl.dart';
import 'package:healthyways/features/medication/data/datasources/medications_remote_data_source.dart';
import 'package:healthyways/features/medication/data/repositories/medication_repository_impl.dart';
import 'package:healthyways/features/medication/domain/repositories/medication_repository.dart';
import 'package:healthyways/features/medication/domain/usecases/add_assigned_medication.dart';
import 'package:healthyways/features/medication/domain/usecases/get_all_medications.dart';
import 'package:healthyways/features/medication/domain/usecases/get_all_medicines.dart';
import 'package:healthyways/features/medication/domain/usecases/get_medicine_by_id.dart';
import 'package:healthyways/features/medication/domain/usecases/toggle_medication_status_by_id.dart';
import 'package:healthyways/features/medication/presentation/controllers/medication_controller.dart';
import 'package:healthyways/features/patient/data/datasources/patient_remote_data_source.dart';
import 'package:healthyways/features/patient/data/repositories/patient_repository_impl.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';
import 'package:healthyways/features/patient/domain/usecases/add_my_provider.dart';
import 'package:healthyways/features/patient/domain/usecases/get_all_patients.dart';
import 'package:healthyways/features/patient/domain/usecases/get_medicine_by_id.dart';
import 'package:healthyways/features/patient/domain/usecases/get_my_providers.dart';
import 'package:healthyways/features/patient/domain/usecases/get_patient_by_id.dart';
import 'package:healthyways/features/patient/domain/usecases/patient_get_all_medications.dart';
import 'package:healthyways/features/patient/domain/usecases/patient_get_measurement_entries.dart';
import 'package:healthyways/features/patient/domain/usecases/remove_my_provider.dart';
import 'package:healthyways/features/patient/domain/usecases/toggle_medication_status_by_id.dart';
import 'package:healthyways/features/patient/domain/usecases/update_patient_profile.dart';
import 'package:healthyways/features/patient/domain/usecases/update_visibility_settings.dart';
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
import 'package:healthyways/features/immunization/domain/repositories/immunization_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize dependencies here

  await dotenv.load(fileName: ".env");

  final supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  serviceLocator.registerSingleton<SupabaseClient>(supabase.client);

  // Initialize feature-specific dependencies
  // Do not change the secquence of initlization some features depend on others
  _initAuth();

  _initPatient();
  _initDoctor();
  _initPharmacist();

  _initMedications();
  _initUpdates();
  _initMeasurements();
  _initDiary();
  _initImmunization();
  _initAllergies();
}

void _initAuth() {
  // Data sources
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
  );

  // Repositories
  serviceLocator.registerFactory<AuthRepository>(() => AuthRepositoryImpl(serviceLocator<AuthRemoteDataSource>()));

  // Use cases
  serviceLocator
    ..registerFactory<UserSignIn>(() => UserSignIn(serviceLocator<AuthRepository>()))
    ..registerFactory<UserSignUp>(() => UserSignUp(serviceLocator<AuthRepository>()))
    ..registerFactory<UserSignOut>(() => UserSignOut(serviceLocator<AuthRepository>()))
    ..registerFactory<CurrentProfile>(() => CurrentProfile(serviceLocator<AuthRepository>()));

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
    () => PatientRemoteDataSourceImpl(
      supabaseClient: serviceLocator<SupabaseClient>(),
      appProfileController: serviceLocator<AppProfileController>(),
    ),
  );

  // Repositories
  serviceLocator.registerFactory<PatientRepository>(
    () => PatientRepositoryImpl(serviceLocator<PatientRemoteDataSource>()),
  );

  // Use cases
  serviceLocator
    ..registerFactory<GetAllPatients>(() => GetAllPatients(serviceLocator<PatientRepository>()))
    ..registerFactory<GetPatientById>(() => GetPatientById(serviceLocator<PatientRepository>()))
    ..registerFactory<UpdatePatientProfile>(() => UpdatePatientProfile(serviceLocator<PatientRepository>()))
    // ..registerFactory<UpdateGlobalVisibility>(() => UpdateGlobalVisibility(serviceLocator<PatientRepository>()))
    ..registerFactory<PatientGetAllMedications>(() => PatientGetAllMedications(serviceLocator<PatientRepository>()))
    ..registerFactory<UpdateVisibilitySettings>(() => UpdateVisibilitySettings(serviceLocator<PatientRepository>()))
    ..registerFactory<patient.AddMeasurementEntry>(
      () => patient.AddMeasurementEntry(serviceLocator<PatientRepository>()),
    )
    ..registerFactory<PatientGetMedicineById>(() => PatientGetMedicineById(serviceLocator<PatientRepository>()))
    ..registerFactory<PatientToggleMedicationStatusById>(
      () => PatientToggleMedicationStatusById(serviceLocator<PatientRepository>()),
    )
    ..registerFactory<PatientGetMeasurementEntries>(
      () => PatientGetMeasurementEntries(serviceLocator<PatientRepository>()),
    )
    ..registerFactory<GetMyProviders>(() => GetMyProviders(serviceLocator<PatientRepository>()))
    ..registerFactory<AddMyProvider>(() => AddMyProvider(serviceLocator<PatientRepository>()))
    ..registerFactory<RemoveMyProvider>(() => RemoveMyProvider(serviceLocator<PatientRepository>()));

  // Controller
  serviceLocator.registerSingleton<PatientController>(
    PatientController(
      getAllPatients: serviceLocator<GetAllPatients>(),
      getPatientById: serviceLocator<GetPatientById>(),
      updatePatientProfile: serviceLocator<UpdatePatientProfile>(),
      // updateGlobalVisibility: serviceLocator<UpdateGlobalVisibility>(),
      updateVisibilitySettings: serviceLocator<UpdateVisibilitySettings>(),
      getAllMedications: serviceLocator<PatientGetAllMedications>(),
      addMeasurementEntry: serviceLocator<patient.AddMeasurementEntry>(),
      getMedicineById: serviceLocator<PatientGetMedicineById>(),
      toggleMedicationStatusById: serviceLocator<PatientToggleMedicationStatusById>(),
      patientGetMeasurementEntries: serviceLocator<PatientGetMeasurementEntries>(),

      getMyProviders: serviceLocator<GetMyProviders>(),
      addMyProvider: serviceLocator<AddMyProvider>(),
      removeMyProvider: serviceLocator<RemoveMyProvider>(),
    ),
  );
}

void _initMedications() {
  // Data sources
  serviceLocator.registerFactory<MedicationsRemoteDataSource>(
    () => MedicationsRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
    //TODO: replace with actual Datasource
  );

  // Repositories
  serviceLocator.registerFactory<MedicationRepository>(
    () => MedicationRepositoryImpl(serviceLocator<MedicationsRemoteDataSource>()),
  );

  // Use cases
  serviceLocator
    ..registerFactory<GetAllMedicines>(() => GetAllMedicines(serviceLocator<MedicationRepository>()))
    ..registerFactory<GetAllMedications>(() => GetAllMedications(serviceLocator<MedicationRepository>()))
    ..registerFactory<AddAssignedMedication>(() => AddAssignedMedication(serviceLocator<MedicationRepository>()))
    ..registerFactory<ToggleMedicationStatusById>(
      () => ToggleMedicationStatusById(serviceLocator<MedicationRepository>()),
    )
    ..registerFactory<GetMedicineById>(() => GetMedicineById(serviceLocator<MedicationRepository>()));

  // App-level controller
  serviceLocator.registerSingleton(() => AppMedicationsController());

  // Controller
  serviceLocator.registerSingleton<MedicationController>(
    MedicationController(
      getAllMedicines: serviceLocator<GetAllMedicines>(),
      getAllMedications: serviceLocator<GetAllMedications>(),
      toggleMedicationStatusById: serviceLocator<ToggleMedicationStatusById>(),
      addAssignedMedication: serviceLocator<AddAssignedMedication>(),
    ),
  );
}

void _initMeasurements() {
  // Data sources
  serviceLocator.registerFactory<MeasurementRemoteDataSource>(
    () => MeasurementRemoteDataSourceImpl(serviceLocator<SupabaseClient>(), serviceLocator<AppProfileController>()),
  );

  // Repositories
  serviceLocator.registerFactory<MeasurementRepository>(
    () => MeasurementRepositoryImpl(serviceLocator<MeasurementRemoteDataSource>()),
  );

  // Use cases
  serviceLocator
    ..registerFactory<GetAllMeasurements>(() => GetAllMeasurements(serviceLocator<MeasurementRepository>()))
    ..registerFactory<GetMyMeasurements>(() => GetMyMeasurements(serviceLocator<MeasurementRepository>()))
    ..registerFactory<GetMeasurementEntries>(() => GetMeasurementEntries(serviceLocator<MeasurementRepository>()))
    ..registerFactory<AddMeasurementEntry>(() => AddMeasurementEntry(serviceLocator<MeasurementRepository>()))
    ..registerFactory<GetMeasurementVisibility>(() => GetMeasurementVisibility(serviceLocator<MeasurementRepository>()))
    ..registerFactory<UpdateMeasurementVisibility>(
      () => UpdateMeasurementVisibility(serviceLocator<MeasurementRepository>()),
    )
    ..registerFactory<UpdateMyMeasurementReminderSettings>(
      () => UpdateMyMeasurementReminderSettings(serviceLocator<MeasurementRepository>()),
    )
    ..registerFactory<ToggleMyMeasurementStatus>(
      () => ToggleMyMeasurementStatus(serviceLocator<MeasurementRepository>()),
    );

  // Controller
  serviceLocator.registerSingleton<MeasurementController>(
    MeasurementController(
      getAllMeasurements: serviceLocator<GetAllMeasurements>(),
      getMyMeasurements: serviceLocator<GetMyMeasurements>(),
      getMeasurementEntries: serviceLocator<GetMeasurementEntries>(),
      toggleMyMeasurementStatus: serviceLocator<ToggleMyMeasurementStatus>(),
      addMeasurementEntry: serviceLocator<AddMeasurementEntry>(),
      getMeasurementVisibility: serviceLocator<GetMeasurementVisibility>(),
      updateMeasurementVisibility: serviceLocator<UpdateMeasurementVisibility>(),
      appProfileController: serviceLocator<AppProfileController>(),
      updateMyMeasurementReminderSettings: serviceLocator<UpdateMyMeasurementReminderSettings>(),
    ),
  );
}

void _initUpdates() {
  // Data sources
  serviceLocator.registerFactory<IUpdatesRemoteDataSource>(
    () => UpdatesRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
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
      getAllMedicationScheduleReport: serviceLocator<GetAllMedicationScheduleReport>(),
      getPatientById: serviceLocator<GetPatientById>(),
      getMedicineById: serviceLocator<GetMedicineById>(),
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
    ..registerFactory<GetAllDoctors>(() => GetAllDoctors(serviceLocator<DoctorRepository>()))
    ..registerFactory<GetDoctorById>(() => GetDoctorById(serviceLocator<DoctorRepository>()))
    ..registerFactory<UpdateDoctorProfile>(() => UpdateDoctorProfile(serviceLocator<DoctorRepository>()));

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
    () => PharmacistRepositoryImpl(serviceLocator<PharmacistRemoteDataSource>()),
  );

  // Use cases
  serviceLocator
    ..registerFactory<GetAllPharmacists>(() => GetAllPharmacists(serviceLocator<PharmacistRepository>()))
    ..registerFactory<GetPharmacistById>(() => GetPharmacistById(serviceLocator<PharmacistRepository>()))
    ..registerFactory<UpdatePharmacistProfile>(() => UpdatePharmacistProfile(serviceLocator<PharmacistRepository>()));

  // Controller
  serviceLocator.registerSingleton<PharmacistController>(
    PharmacistController(
      getAllPharmacists: serviceLocator<GetAllPharmacists>(),
      getPharmacistById: serviceLocator<GetPharmacistById>(),
      updatePharmacistProfile: serviceLocator<UpdatePharmacistProfile>(),
    ),
  );
}

void _initDiary() {
  // Data sources
  serviceLocator.registerFactory<DiaryRemoteDataSource>(
    () => DiaryRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
  );

  // Repositories
  serviceLocator.registerFactory<DiaryRepository>(() => DiaryRepositoryImpl(serviceLocator<DiaryRemoteDataSource>()));

  // Use cases
  serviceLocator
    ..registerFactory<GetAllDiaryEntries>(() => GetAllDiaryEntries(serviceLocator<DiaryRepository>()))
    ..registerFactory<UpdateDiaryEntry>(() => UpdateDiaryEntry(serviceLocator<DiaryRepository>()))
    ..registerFactory<CreateDiaryEntry>(() => CreateDiaryEntry(serviceLocator<DiaryRepository>()))
    ..registerFactory<DeleteDiaryEntry>(() => DeleteDiaryEntry(serviceLocator<DiaryRepository>()));

  // Controller
  serviceLocator.registerSingleton<DiaryController>(
    DiaryController(
      appProfileController: serviceLocator<AppProfileController>(),
      getAllDiaryEntries: serviceLocator<GetAllDiaryEntries>(),
      updateDiaryEntry: serviceLocator<UpdateDiaryEntry>(),
      createDiaryEntry: serviceLocator<CreateDiaryEntry>(),
      deleteDiaryEntry: serviceLocator<DeleteDiaryEntry>(),
    ),
  );
}

void _initImmunization() {
  // Data sources
  serviceLocator.registerFactory<ImmunizationRemoteDataSource>(
    () => ImmunizationRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
  );

  // Repositories
  serviceLocator.registerFactory<ImmunizationRepository>(
    () => ImmunizationRepositoryImpl(serviceLocator<ImmunizationRemoteDataSource>()),
  );

  // Use cases
  serviceLocator
    ..registerFactory<GetAllImmunizationEntries>(
      () => GetAllImmunizationEntries(serviceLocator<ImmunizationRepository>()),
    )
    ..registerFactory<CreateImmunizationEntry>(() => CreateImmunizationEntry(serviceLocator<ImmunizationRepository>()))
    ..registerFactory<UpdateImmunizationEntry>(() => UpdateImmunizationEntry(serviceLocator<ImmunizationRepository>()))
    ..registerFactory<DeleteImmunizationEntry>(() => DeleteImmunizationEntry(serviceLocator<ImmunizationRepository>()));

  // Controller
  serviceLocator.registerSingleton<ImmunizationController>(
    ImmunizationController(
      appProfileController: serviceLocator<AppProfileController>(),
      getAllImmunizationEntries: serviceLocator<GetAllImmunizationEntries>(),
      createImmunizationEntry: serviceLocator<CreateImmunizationEntry>(),
      updateImmunizationEntry: serviceLocator<UpdateImmunizationEntry>(),
      deleteImmunizationEntry: serviceLocator<DeleteImmunizationEntry>(),
    ),
  );
}

void _initAllergies() {
  // Data sources
  serviceLocator.registerFactory<AllergiesRemoteDataSource>(
    () => AllergiesRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
  );

  // Repositories
  serviceLocator.registerFactory<AllergiesRepository>(
    () => AllergiesRepositoryImpl(serviceLocator<AllergiesRemoteDataSource>()),
  );

  // Use cases
  serviceLocator
    ..registerFactory<GetAllAllergyEntries>(() => GetAllAllergyEntries(serviceLocator<AllergiesRepository>()))
    ..registerFactory<CreateAllergyEntry>(() => CreateAllergyEntry(serviceLocator<AllergiesRepository>()))
    ..registerFactory<UpdateAllergyEntry>(() => UpdateAllergyEntry(serviceLocator<AllergiesRepository>()))
    ..registerFactory<DeleteAllergyEntry>(() => DeleteAllergyEntry(serviceLocator<AllergiesRepository>()));

  // Controller
  serviceLocator.registerSingleton<AllergiesController>(
    AllergiesController(
      appProfileController: serviceLocator<AppProfileController>(),
      getAllAllergieEntries: serviceLocator<GetAllAllergyEntries>(),
      createAllergieEntry: serviceLocator<CreateAllergyEntry>(),
      updateAllergieEntry: serviceLocator<UpdateAllergyEntry>(),
      deleteAllergieEntry: serviceLocator<DeleteAllergyEntry>(),
    ),
  );
}
