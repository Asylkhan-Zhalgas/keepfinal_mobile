import '../auth_failure.dart';
import '../../../data/auth/supabase_auth_service.dart';

class LoginWithEmail {
  final SupabaseAuthService _service;
  LoginWithEmail(this._service);

  Future<void> call({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty) throw const AuthFailure('Введите email');
    if (password.isEmpty) throw const AuthFailure('Введите пароль');

    await _service.signInWithEmail(email: email.trim(), password: password);
  }
}

