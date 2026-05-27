import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart' show AppException, ServerException, NetworkException, ValidationException;
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<TokenModel> login(LoginRequest request);
  Future<UserModel> register(RegisterRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<TokenModel> login(LoginRequest request) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/auth/login',
        data: request.toJson(),
      );
      return TokenModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final errorMessage = e.response!.data?['detail'] ?? 
            e.response!.data?['message'] ?? 
            'Authentication failed';
        
        if (statusCode == 401 || statusCode == 403) {
          throw ValidationException(errorMessage);
        } else if (statusCode == 422) {
          throw ValidationException(errorMessage);
        } else {
          throw ServerException(errorMessage);
        }
      } else {
        throw NetworkException(e.message ?? 'Network error occurred');
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Unknown error occurred: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/auth/register',
        data: request.toJson(),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final errorMessage = e.response!.data?['detail'] ?? 
            e.response!.data?['message'] ?? 
            'Registration failed';
        
        if (statusCode == 400 || statusCode == 422) {
          throw ValidationException(errorMessage);
        } else if (statusCode == 409) {
          throw ValidationException('User already exists');
        } else {
          throw ServerException(errorMessage);
        }
      } else {
        throw NetworkException(e.message ?? 'Network error occurred');
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException('Unknown error occurred: ${e.toString()}');
    }
  }
}
