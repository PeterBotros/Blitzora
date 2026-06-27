import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'cached_user';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  String? getToken() => _prefs.getString(_tokenKey);

  Future<bool> saveToken(String token) => _prefs.setString(_tokenKey, token);

  Future<bool> clearToken() => _prefs.remove(_tokenKey);

  String? getUser() => _prefs.getString(_userKey);

  Future<bool> saveUser(String userJson) =>
      _prefs.setString(_userKey, userJson);

  Future<bool> clearUser() => _prefs.remove(_userKey);

  bool get isLoggedIn => getToken() != null;

  Future<void> clearAll() async {
    await clearToken();
    await clearUser();
  }
}
