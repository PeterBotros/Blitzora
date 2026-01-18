import '../../../../core/storage/storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final StorageService storageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<TokenModel> login(LoginRequest request) async {
    final tokenModel = await remoteDataSource.login(request);
    await storageService.saveToken(tokenModel.accessToken);
    return tokenModel;
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    final userModel = await remoteDataSource.register(request);
    await storageService.saveUserId(userModel.id);
    return userModel;
  }

  @override
  Future<void> logout() async {
    await storageService.clearAll();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await storageService.getToken();
    return token != null && token.isNotEmpty;
  }
}
