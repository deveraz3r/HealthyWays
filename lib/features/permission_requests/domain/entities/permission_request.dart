enum PermissionStatus { pending, accepted, rejected }

class PermissionRequest {
  final String id;
  final String patientId;
  final String doctorId;
  final PermissionStatus status;
  final DateTime requestedAt;

  PermissionRequest({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.status,
    required this.requestedAt,
  });

  @override
  String toString() {
    return 'PermissionRequest(id: $id, patientId: $patientId, doctorId: $doctorId, status: $status, requestedAt: $requestedAt)';
  }
}
