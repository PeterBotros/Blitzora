/// Register request model
class RegisterRequest {
  final String email;
  final String username;
  final String password;
  final String? fullName;
  final String? phone;
  RegisterRequest({
    required this.email,
    required this.username,
    required this.password,
    this.fullName,
    this.phone,
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
    if (phone != null && phone!.isNotEmpty) {
      json['phone'] = phone!;
    }
    return json;
  }
}
