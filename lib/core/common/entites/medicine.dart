import 'package:healthyways/core/common/custom_types/shape.dart';

class Medicine {
  String id;
  String name;
  int dosage;
  String unit;
  Shape shape;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.unit,
    required this.shape,
  });
}
