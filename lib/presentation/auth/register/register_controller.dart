import 'package:flutter/foundation.dart';

import '../../../data/auth/supabase_auth_service.dart';
import '../../../domain/auth/auth_failure.dart';
import '../../../domain/auth/usecases/register_with_email.dart';

class RegisterController extends ChangeNotifier {
  final RegisterWithEmail _register;

  RegisterController({RegisterWithEmail? registerWithEmail})
      : _register =
            registerWithEmail ?? RegisterWithEmail(SupabaseAuthService());

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> submit({
    required String email,
    required String password,
  }) async {
    if (_isLoading) return false;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _register(email: email, password: password);
      return true;
    } on AuthFailure catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      _error = 'Не удалось зарегистрироваться. Попробуйте ещё раз.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

