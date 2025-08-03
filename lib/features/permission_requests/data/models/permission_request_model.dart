import 'package:healthyways/core/common/entites/doctor_profile.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/features/permission_requests/domain/entities/permission_request.dart';

extension PermissionStatusExtension on PermissionStatus {
  String toShortString() => toString().split('.').last;

  static PermissionStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return PermissionStatus.accepted;
      case 'rejected':
        return PermissionStatus.rejected;
      case 'pending':
      default:
        return PermissionStatus.pending;
    }
  }
}

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

  factory PermissionRequest.fromJson(Map<String, dynamic> json) {
    return PermissionRequest(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      status: PermissionStatusExtension.fromString(json['status'] ?? 'pending'),
      requestedAt: DateTime.parse(json['requestedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'status': status.toShortString(),
      'requestedAt': requestedAt.toIso8601String(),
    };
  }

  PermissionRequest copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    PermissionStatus? status,
    DateTime? requestedAt,
  }) {
    return PermissionRequest(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
    );
  }

  /// Creates a PermissionRequest using patient and doctor profiles
  static PermissionRequest fromProfiles({
    required PatientProfile patient,
    required DoctorProfile doctor,
    required String requestId,
    PermissionStatus status = PermissionStatus.pending,
    DateTime? requestedAt,
  }) {
    return PermissionRequest(
      id: requestId,
      patientId: patient.uid,
      doctorId: doctor.uid,
      status: status,
      requestedAt: requestedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'PermissionRequest(id: $id, patientId: $patientId, doctorId: $doctorId, status: $status, requestedAt: $requestedAt)';
  }
}
