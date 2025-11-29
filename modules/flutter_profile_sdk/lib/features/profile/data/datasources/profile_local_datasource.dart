import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> cacheUserProfile(UserModel user);
  Future<UserModel?> getLastUserProfile(int userId);
}

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences _prefs;

  ProfileLocalDataSourceImpl(this._prefs);

  static const _cachedProfileKeyPrefix = 'CACHED_USER_PROFILE_';

  @override
  Future<void> cacheUserProfile(UserModel user) async {
    final jsonString = json.encode(user.toJson());
    await _prefs.setString('$_cachedProfileKeyPrefix${user.id}', jsonString);
  }

  @override
  Future<UserModel?> getLastUserProfile(int userId) async {
    final jsonString = _prefs.getString('$_cachedProfileKeyPrefix$userId');
    if (jsonString != null) {
      try {
        return UserModel.fromJson(json.decode(jsonString));
      } catch (e) {
        // En cas d'erreur de parsing (ex: changement de structure), on ignore le cache
        return null;
      }
    }
    return null;
  }
}
