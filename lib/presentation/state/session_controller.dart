import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionController extends ChangeNotifier {
  StreamSubscription<AuthState>? _sub;
  Session? _session;

  bool get isSignedIn => _session != null;
  Session? get session => _session;

  void init() {
    _session = Supabase.instance.client.auth.currentSession;
    _sub?.cancel();
    _sub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      _session = data.session;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

