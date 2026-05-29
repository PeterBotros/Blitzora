/// Storage service interface for managing authentication tokens
abstract class StorageService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<void> saveUserId(int userId);
  Future<int?> getUserId();
  Future<void> deleteUserId();
  Future<void> clearAll();
}

/// In-memory implementation of StorageService
/// TODO: Replace with SharedPreferences or secure storage for production
class MemoryStorageService implements StorageService {
  String? _token;
  int? _userId;

  @override
  Future<void> saveToken(String token) async {
    _token = token;
  }

  @override
  Future<String?> getToken() async {
    return _token;
  }

  @override
  Future<void> deleteToken() async {
    _token = null;
  }

  @override
  Future<void> saveUserId(int userId) async {
    _userId = userId;
  }

  @override
  Future<int?> getUserId() async {
    return _userId;
  }

  @override
  Future<void> deleteUserId() async {
    _userId = null;
  }

  @override
  Future<void> clearAll() async {
    _token = null;
    _userId = null;
  }
}
