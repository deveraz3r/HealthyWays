import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/theme/app_pallete.dart';
import 'package:healthyways/features/permission_requests/domain/entities/permission_request.dart';
import 'package:healthyways/features/permission_requests/presentation/controllers/premission_request_controller.dart';
import 'package:healthyways/features/permission_requests/presentation/widgets/premission_request_tile.dart';

class PermissionRequestsPage extends StatefulWidget {
  const PermissionRequestsPage({super.key});

  @override
  State<PermissionRequestsPage> createState() => _PermissionRequestsPageState();
}

class _PermissionRequestsPageState extends State<PermissionRequestsPage> {
  final controller = Get.find<PermissionRequestController>();

  @override
  void initState() {
    super.initState();
    controller.fetchIncomingRequests();
    controller.fetchOutgoingRequests();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Get.find<AppProfileController>().profile.data!;
    final isPatient = profile.selectedRole == Role.patient;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          /// Custom TabBar (not in AppBar)
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TabBar(
              labelColor: AppPallete.gradient1,
              unselectedLabelColor: AppPallete.greyColor,
              indicatorColor: AppPallete.gradient1,
              tabs: const [Tab(text: 'Incoming'), Tab(text: 'Outgoing')],
            ),
          ),

          /// Tab Content
          Expanded(
            child: TabBarView(
              children: [
                /// Incoming Requests
                Obx(() {
                  if (controller.incomingRequests.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.incomingRequests.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${controller.incomingRequests.error}',
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: controller.fetchIncomingRequests,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final requests = controller.incomingRequests.data ?? [];

                  if (requests.isEmpty) {
                    return const Center(
                      child: Text(
                        'No incoming requests.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: requests.length,
                    itemBuilder: (_, index) {
                      final request = requests[index];
                      return PermissionRequestTile(
                        request: request,
                        isIncoming: true,
                        onAccept:
                            () => controller.updateRequestStatus(
                              request,
                              PermissionStatus.accepted,
                            ),
                        onReject:
                            () => controller.updateRequestStatus(
                              request,
                              PermissionStatus.rejected,
                            ),
                      );
                    },
                  );
                }),

                /// Outgoing Requests
                Obx(() {
                  if (controller.outgoingRequests.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.outgoingRequests.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${controller.outgoingRequests.error}',
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: controller.fetchOutgoingRequests,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final requests = controller.outgoingRequests.data ?? [];

                  if (requests.isEmpty) {
                    return const Center(
                      child: Text(
                        'No outgoing requests.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: requests.length,
                    itemBuilder: (_, index) {
                      final request = requests[index];
                      return PermissionRequestTile(
                        request: request,
                        isIncoming: false,
                        onDelete: () {
                          controller.deletePermissionRequest(request.id);
                        },
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
