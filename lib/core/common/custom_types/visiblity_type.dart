enum VisiblityType { global, all, doctors, pharmacist, custom, private }

extension VisiblityTypeExtension on VisiblityType {
  String toJson() => name;

  static VisiblityType fromJson(String value) {
    return VisiblityType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => VisiblityType.private, // fallback (optional)
    );
  }
}
