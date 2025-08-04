import 'package:flutter/material.dart';
import 'package:healthyways/features/permission_requests/domain/entities/permission_request.dart';

class PermissionRequestTile extends StatelessWidget {
  final PermissionRequest request;
  final bool isIncoming;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onDelete;

  const PermissionRequestTile({
    Key? key,
    required this.request,
    required this.isIncoming,
    this.onAccept,
    this.onReject,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          isIncoming
              ? 'From: ${request.createdByRole}'
              : 'To: ${request.createdByRole == 'patient' ? request.providerId : request.patientId}',
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Patient ID: ${request.patientId}"),
            Text("Provider ID: ${request.providerId}"),
            Text("Status: ${request.status.name}"),
          ],
        ),
        trailing: _buildActions(),
      ),
    );
  }

  Widget? _buildActions() {
    if (isIncoming && request.status == PermissionStatus.pending) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: onAccept,
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: onReject,
          ),
        ],
      );
    } else if (!isIncoming && request.status == PermissionStatus.pending) {
      return IconButton(icon: const Icon(Icons.delete), onPressed: onDelete);
    }
    return null;
  }
}
