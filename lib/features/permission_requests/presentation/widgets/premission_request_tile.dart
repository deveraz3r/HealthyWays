import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/features/permission_requests/domain/entities/permission_request.dart';
import 'package:healthyways/features/permission_requests/presentation/controllers/premission_request_controller.dart';
import 'package:shimmer/shimmer.dart';

class PermissionRequestTile extends StatefulWidget {
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
  State<PermissionRequestTile> createState() => _PermissionRequestTileState();
}

class _PermissionRequestTileState extends State<PermissionRequestTile> {
  String? userEmail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
    final controller = Get.find<PermissionRequestController>();

    final id =
        widget.isIncoming
            ? (widget.request.createdByRole == 'patient'
                ? widget.request.patientId
                : widget.request.providerId)
            : (widget.request.createdByRole == 'patient'
                ? widget.request.providerId
                : widget.request.patientId);

    final email = await controller.getEmailById(id);

    if (mounted) {
      setState(() {
        userEmail = email;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final titlePrefix = widget.isIncoming ? 'From: ' : 'To: ';
    final title =
        isLoading
            ? Shimmer.fromColors(
              baseColor: Colors.grey[700]!,
              highlightColor: Colors.grey[500]!,
              child: Container(height: 14, width: 140, color: Colors.grey[700]),
            )
            : Text(
              '$titlePrefix$userEmail',
              style: const TextStyle(fontWeight: FontWeight.w600),
            );

    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.grey[900],
      child: ListTile(
        title: title,
        subtitle: Text(
          "Status: ${widget.request.status.name.capitalizeFirst}",
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: _buildActions(),
      ),
    );
  }

  Widget? _buildActions() {
    if (widget.isIncoming &&
        widget.request.status == PermissionStatus.pending) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: widget.onAccept,
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: widget.onReject,
          ),
        ],
      );
    } else if (!widget.isIncoming &&
        widget.request.status == PermissionStatus.pending) {
      return IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: widget.onDelete,
      );
    }
    return null;
  }
}
