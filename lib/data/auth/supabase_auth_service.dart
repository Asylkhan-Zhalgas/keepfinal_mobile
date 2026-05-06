import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/auth/auth_failure.dart';

class SupabaseAuthService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure('Не удалось зарегистрироваться. Попробуйте ещё раз.');
    }
  }
}

