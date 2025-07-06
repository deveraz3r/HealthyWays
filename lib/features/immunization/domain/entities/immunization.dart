class Immunization {
  final String id;
  final String patientId;
  final String? providerId;
  final String title;
  final String body;
  final DateTime lastUpdated;
  final DateTime createdAt;

  const Immunization({
    required this.id,
    required this.patientId,
    this.providerId,
    required this.title,
    required this.body,
    required this.lastUpdated,
    required this.createdAt,
  });
}
