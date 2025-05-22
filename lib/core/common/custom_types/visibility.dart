import 'package:healthyways/core/common/custom_types/visibility_type.dart';

class Visibility {
  final VisibilityType type;
  final List<String> customAccess;

  Visibility({required this.type, required this.customAccess});

  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(), // serialize using the extension method
      'customAccess': customAccess,
    };
  }

  factory Visibility.fromJson(Map<String, dynamic> json) {
    return Visibility(
      type: VisiblityTypeExtension.fromJson(json['type']),
      customAccess: List<String>.from(json['customAccess'] ?? []),
    );
  }
}
