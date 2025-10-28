import 'package:agridash/core/models/user.dart';

class AuthResult {
  final bool success;
  final User? user;
  final String? token;
  final String? error;

  AuthResult({
    required this.success,
    this.user,
    this.token,
    this.error,
  });
}