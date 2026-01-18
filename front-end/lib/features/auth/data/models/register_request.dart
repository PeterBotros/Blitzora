/// Register request model
class RegisterRequest {
  final String email;
  final String username;
  final String password;
  final String? fullName;

  RegisterRequest({
    required this.email,
    required this.username,
    required this.password,
    this.fullName,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'email': email,
      'username': username,
      'password': password,
    };
    if (fullName != null && fullName!.isNotEmpty) {
      json['full_name'] = fullName!;
    }
    return json;
  }
}
