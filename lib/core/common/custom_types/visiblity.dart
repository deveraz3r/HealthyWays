import 'package:healthyways/core/common/custom_types/visiblity_type.dart';

class Visiblity {
  final VisiblityType type;
  final List<String> customAccess;

  Visiblity({required this.type, required this.customAccess});

  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(), // serialize using the extension method
      'customAccess': customAccess,
    };
  }

  factory Visiblity.fromJson(Map<String, dynamic> json) {
    return Visiblity(
      type: VisiblityTypeExtension.fromJson(json['type']),
      customAccess: List<String>.from(json['customAccess'] ?? []),
    );
  }
}
