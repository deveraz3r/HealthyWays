class Rating {
  final String raterId; // The user who rated
  final int stars; // 1 to 5
  final String? comment; // Optional feedback
  final DateTime createdAt;

  Rating({
    required this.raterId,
    required this.stars,
    this.comment,
    DateTime? createdAt,
  }) : assert(stars >= 1 && stars <= 5, 'Stars must be between 1 and 5'),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'raterId': raterId,
      'stars': stars,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      raterId: json['raterId'],
      stars: json['stars'],
      comment: json['comment'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
    );
  }
}
