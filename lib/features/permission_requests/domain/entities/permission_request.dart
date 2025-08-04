enum PermissionStatus { pending, accepted, rejected }

class PermissionRequest {
  final String id;
  final String patientId;
  final String providerId;
  final PermissionStatus status;
  final DateTime requestedAt;
  final String createdByRole;

  PermissionRequest({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.status,
    required this.requestedAt,
    required this.createdByRole,
  });

  @override
  String toString() {
    return 'PermissionRequest(id: $id, patientId: $patientId, providerId: $providerId, status: $status, requestedAt: $requestedAt, createdByRole: $createdByRole)';
  }
}
