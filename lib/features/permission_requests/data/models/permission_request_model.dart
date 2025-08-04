import 'package:healthyways/core/common/entites/doctor_profile.dart';
import 'package:healthyways/core/common/entites/patient_profile.dart';
import 'package:healthyways/features/permission_requests/domain/entities/permission_request.dart';

/// Extension to handle conversions between enum and string safely
extension PermissionStatusExtension on PermissionStatus {
  String toShortString() {
    switch (this) {
      case PermissionStatus.accepted:
        return 'accepted';
      case PermissionStatus.rejected:
        return 'rejected';
      case PermissionStatus.pending:
        return 'pending';
    }
  }

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

class PermissionRequestModel extends PermissionRequest {
  PermissionRequestModel({
    required super.id,
    required super.patientId,
    required super.providerId,
    required super.status,
    required super.requestedAt,
    required super.createdByRole,
  });

  /// Safely parses JSON into model
  factory PermissionRequestModel.fromJson(Map<String, dynamic> json) {
    return PermissionRequestModel(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      providerId: json['providerId'] ?? '',
      status: PermissionStatusExtension.fromString(json['status'] ?? 'pending'),
      requestedAt:
          json['requestedAt'] != null
              ? DateTime.tryParse(json['requestedAt']) ?? DateTime.now()
              : DateTime.now(),
      createdByRole: json['createdByRole'] ?? '',
    );
  }

  /// Converts model to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'providerId': providerId,
      'status': status.toShortString(),
      'requestedAt': requestedAt.toIso8601String(),
      'createdByRole': createdByRole,
    };
  }

  /// Creates a copy of the model with optional overrides
  PermissionRequestModel copyWith({
    String? id,
    String? patientId,
    String? providerId,
    PermissionStatus? status,
    DateTime? requestedAt,
    String? createdByRole,
  }) {
    return PermissionRequestModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      providerId: providerId ?? this.providerId,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      createdByRole: createdByRole ?? this.createdByRole,
    );
  }

  /// Converts a base class instance to a model
  static PermissionRequestModel fromPermissionRequest(
    PermissionRequest request,
  ) {
    return PermissionRequestModel(
      id: request.id,
      patientId: request.patientId,
      providerId: request.providerId,
      status: request.status,
      requestedAt: request.requestedAt,
      createdByRole: request.createdByRole,
    );
  }

  @override
  String toString() {
    return 'PermissionRequestModel(id: $id, patientId: $patientId, providerId: $providerId, status: $status, requestedAt: $requestedAt, createdByRole: $createdByRole)';
  }
}
