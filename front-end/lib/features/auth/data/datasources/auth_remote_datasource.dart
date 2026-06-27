import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/storage_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    required String fullName,
    required String phone,
  });
  Future<UserModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  final StorageService _storageService;

  AuthRemoteDataSourceImpl(this._apiClient, this._storageService);

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      final token = response.data['access_token'] as String;
      await _storageService.saveToken(token);
      return token;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: {
          'email': email,
          'username': username,
          'password': password,
          'full_name': fullName,
          'phone': phone,
        },
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await _apiClient.get(ApiConstants.me);
      final user = UserModel.fromJson(response.data as Map<String, dynamic>);
      await _storageService.saveUser(user.toJsonString());
      return user;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
