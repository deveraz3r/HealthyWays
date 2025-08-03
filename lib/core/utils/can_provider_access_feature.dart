import 'package:healthyways/core/common/custom_types/access_result.dart';
import 'package:healthyways/core/common/custom_types/visibility.dart';
import 'package:healthyways/core/common/custom_types/visibility_type.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';

/// Returns an [AccessResult] indicating if the provider has access and a message explaining the result.
AccessResult canProviderAccessFeature({
  required PatientProfile patient,
  required String providerId,
  required Visibility featureVisibility,
}) {
  final global = patient.globalVisibility;

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

  // If global is disabled, check feature-specific visibility
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
