import 'package:healthyways/core/common/custom_types/access_result.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/common/custom_types/visibility_type.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';

/// Checks if a provider has access to a specific measurement entry for a patient.
AccessResult canProviderAccessMeasurement({
  required PatientProfile patient,
  required String providerId,
  required String measurementId,
}) {
  final global = patient.globalVisibility;

  // Find the measurement's visibility settings
  final myMeasurement = patient.myMeasurements.firstWhere(
    (m) => m.id == measurementId,
    // orElse: () => null,
  );

  // If measurement not found, deny access
  if (myMeasurement == null) {
    return AccessResult(isAllowed: false, message: 'Measurement not found.');
  }

  final featureVisibility = myMeasurement.visiblity;

  // Global visibility overrides all
  if (global.type != VisibilityType.disabled) {
    switch (global.type) {
      case VisibilityType.myProviders:
        if (patient.myProviders.contains(providerId)) {
          return AccessResult(isAllowed: true, message: '');
        }
        return AccessResult(
          isAllowed: false,
          message: 'You are not a listed provider for this patient.',
        );

      case VisibilityType.custom:
        if (global.customAccess.contains(providerId)) {
          return AccessResult(isAllowed: true, message: '');
        }
        return AccessResult(
          isAllowed: false,
          message: 'You do not have permission to view this data.',
        );

      case VisibilityType.private:
        return AccessResult(
          isAllowed: false,
          message: 'This information is private.',
        );

      default:
        return AccessResult(isAllowed: false, message: 'Access is restricted.');
    }
  }

  // If global is disabled, check measurement-specific visibility
  switch (featureVisibility.type) {
    case VisibilityType.myProviders:
      if (patient.myProviders.contains(providerId)) {
        return AccessResult(isAllowed: true, message: '');
      }
      return AccessResult(
        isAllowed: false,
        message: 'You are not a listed provider for this patient.',
      );

    case VisibilityType.custom:
      if (featureVisibility.customAccess.contains(providerId)) {
        return AccessResult(isAllowed: true, message: '');
      }
      return AccessResult(
        isAllowed: false,
        message: 'You do not have permission to view this data.',
      );

    case VisibilityType.private:
      return AccessResult(
        isAllowed: false,
        message: 'This information is private.',
      );

    default:
      return AccessResult(isAllowed: false, message: 'Access is restricted.');
  }
}
