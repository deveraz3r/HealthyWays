import 'package:fpdart/fpdart.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/error/failure.dart';
import 'package:healthyways/core/usecase/usecase.dart';
import 'package:healthyways/features/patient/domain/repositories/patient_repository.dart';

class UpdateVisibilitySettings implements UseCase<void, UpdateVisibilitySettingsParams> {
  final PatientRepository repository;

  const UpdateVisibilitySettings(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateVisibilitySettingsParams params) async {
    return await repository.updateVisibilitySettings(featureId: params.featureId, visibility: params.visibility);
  }
}

class UpdateVisibilitySettingsParams {
  final String featureId;
  final Visibility visibility;

  const UpdateVisibilitySettingsParams({required this.featureId, required this.visibility});
}
