import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:healthyways/core/constants/supabase/supabase_tables.dart';
import 'package:healthyways/core/error/exceptions.dart';
import 'package:healthyways/features/permission_requests/data/models/permission_request_model.dart';
import 'package:healthyways/features/permission_requests/domain/entities/permission_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PermissionRequestRemoteDataSource {
  Future<void> createPermissionRequest(PermissionRequestModel request);
  Future<List<PermissionRequestModel>> getIncomingRequests(
    String userId,
    Role role,
  );
  Future<List<PermissionRequestModel>> getOutgoingRequests(
    String userId,
    Role role,
  );
  Future<void> updateRequestStatus({
    required String requestId,
    required PermissionStatus status,
  });
  Future<void> deleteRequest(String requestId);
}

class PermissionRequestRemoteDataSourceImpl
    implements PermissionRequestRemoteDataSource {
  final SupabaseClient supabaseClient;

  PermissionRequestRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> createPermissionRequest(PermissionRequestModel request) async {
    try {
      await supabaseClient
          .from(SupabaseTables.permissionRequestsTable)
          .insert(request.toJson());
    } catch (e) {
      throw ServerException('Failed to create permission request: $e');
    }
  }

  @override
  Future<List<PermissionRequestModel>> getIncomingRequests(
    String userId,
    Role role,
  ) async {
    try {
      final field = role == Role.doctor ? 'providerId' : 'patientId';

      final response = await supabaseClient
          .from(SupabaseTables.permissionRequestsTable)
          .select()
          .eq(field, userId)
          .neq('createdByRole', role.toJson())
          .order('requestedAt', ascending: false);

      return (response as List)
          .map((e) => PermissionRequestModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch incoming requests: $e');
    }
  }

  @override
  Future<List<PermissionRequestModel>> getOutgoingRequests(
    String userId,
    Role role,
  ) async {
    try {
      final field = role == Role.doctor ? 'providerId' : 'patientId';

      final response = await supabaseClient
          .from(SupabaseTables.permissionRequestsTable)
          .select()
          .eq(field, userId)
          .eq('createdByRole', role.toJson())
          .order('requestedAt', ascending: false);

      return (response as List)
          .map((e) => PermissionRequestModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch outgoing requests: $e');
    }
  }

  @override
  Future<void> updateRequestStatus({
    required String requestId,
    required PermissionStatus status,
  }) async {
    try {
      await supabaseClient
          .from(SupabaseTables.permissionRequestsTable)
          .update({'status': status.toShortString()})
          .eq('id', requestId);
    } catch (e) {
      throw ServerException('Failed to update request status: $e');
    }
  }

  @override
  Future<void> deleteRequest(String requestId) async {
    try {
      await supabaseClient
          .from(SupabaseTables.permissionRequestsTable)
          .delete()
          .eq('id', requestId);
    } catch (e) {
      throw ServerException('Failed to delete request: $e');
    }
  }
}
