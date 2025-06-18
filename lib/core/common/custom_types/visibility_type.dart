enum VisibilityType { global, all, doctors, pharmacist, custom, private, disabled }

extension VisiblityTypeExtension on VisibilityType {
  String toJson() => name;

  static VisibilityType fromJson(String? value) {
    if (value == null) {
      return VisibilityType.private; // Fallback to a default value
    }
    return VisibilityType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => VisibilityType.private, // Fallback if value doesn't match
    );
  }
}
