import 'package:healthyways/core/common/custom_types/role.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalDataSource {
  void cacheUserRole(Role role);
  Role? getCachedUserRole();
  void clearCachedUserRole();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  static const String _userRoleKey = 'USER_ROLE';

  @override
  void cacheUserRole(Role role) {
    sharedPreferences.setString(_userRoleKey, role.name);
  }

  @override
  Role? getCachedUserRole() {
    try {
      final roleString = sharedPreferences.getString(_userRoleKey);
      if (roleString != null) {
        return Role.values.firstWhere((role) => role.name == roleString);
      }
      return null;
    } catch (e) {
      // throw Exception('No cached user role found');
      return null;
    }
  }

  @override
  void clearCachedUserRole() {
    sharedPreferences.remove(_userRoleKey);
  }
}
