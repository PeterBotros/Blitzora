import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../data/models/token_model.dart';
import '../../data/models/user_model.dart';

/// Authentication repository interface
abstract class AuthRepository {
  Future<TokenModel> login(LoginRequest request);
  Future<UserModel> register(RegisterRequest request);
  Future<void> logout();
  Future<bool> isAuthenticated();
}
