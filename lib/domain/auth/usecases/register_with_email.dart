import '../auth_failure.dart';
import '../../../data/auth/supabase_auth_service.dart';

class RegisterWithEmail {
  final SupabaseAuthService _service;
  RegisterWithEmail(this._service);

  Future<void> call({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty) throw const AuthFailure('Введите email');
    if (password.length < 6) {
      throw const AuthFailure('Пароль должен быть минимум 6 символов');
    }

    await _service.signUpWithEmail(email: email.trim(), password: password);
  }
}

