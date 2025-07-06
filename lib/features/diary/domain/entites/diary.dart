class Diary {
  String id;
  String patientId;
  String? providerId;
  String title;
  String body;
  DateTime lastUpdated;
  DateTime createdAt;

  Diary({
    required this.id,
    required this.patientId,
    this.providerId,
    required this.title,
    required this.body,
    required this.lastUpdated,
    required this.createdAt,
  });
}
