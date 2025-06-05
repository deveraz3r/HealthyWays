class MeasurementEntry {
  String id;
  String measurementId;
  String patientId;
  String value;
  String note;
  // DateTime createdAt; //not included on client side
  DateTime lastUpdated;

  MeasurementEntry({
    required this.id,
    required this.measurementId,
    required this.patientId,
    required this.value,
    required this.note,
    required this.lastUpdated,
  });
}
