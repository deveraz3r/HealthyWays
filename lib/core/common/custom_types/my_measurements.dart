import 'package:healthyways/core/common/custom_types/visibility.dart';

class MyMeasurements {
  String id;
  Visibility visiblity;
  bool isActive;

  MyMeasurements({
    required this.id,
    required this.visiblity,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'visiblity': visiblity.toJson(),
      "isActive": isActive,
    };
  }

  factory MyMeasurements.fromJson(Map<String, dynamic> json) {
    return MyMeasurements(
      id: json['id'] ?? "",
      visiblity: Visibility.fromJson(json['visiblity']),
      isActive: json["isActive"] ?? false,
    );
  }
}
