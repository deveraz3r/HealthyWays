import 'package:healthyways/core/common/custom_types/visiblity.dart';

class MyMeasurements {
  String id;
  Visiblity visiblity;
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
      visiblity: Visiblity.fromJson(json['visiblity']),
      isActive: json["isActive"] ?? false,
    );
  }
}
