class Shape {
  String image;
  String primaryColorHex;
  String? secondryColorHex;

  Shape({
    required this.image,
    required this.primaryColorHex,
    this.secondryColorHex,
  });

  factory Shape.fromJson(Map<String, dynamic> json) {
    return Shape(
      image: json['image'] ?? '',
      primaryColorHex: json['primaryColorHex'] ?? '',
      secondryColorHex: json['secondryColorHex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'primaryColorHex': primaryColorHex,
      'secondryColorHex': secondryColorHex,
    };
  }
}
