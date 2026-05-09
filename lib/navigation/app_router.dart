import 'package:go_router/go_router.dart';

import '../domain/entries/entities/entry.dart';
import '../presentation/auth/login/login_screen.dart';
import '../presentation/auth/register/register_screen.dart';
import '../presentation/calendar/calendar_screen.dart';
import '../presentation/entries/entry_editor/entry_editor_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/settings/settings_screen.dart';
import '../presentation/shell/app_shell.dart';
import '../presentation/state/session_controller.dart';

class AppRouter {
  static GoRouter create(SessionController sessionController) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: sessionController,
      redirect: (context, state) {
        final signedIn = sessionController.isSignedIn;
        final location = state.matchedLocation;
        final goingToAuth = location == '/register' || location == '/login';
        final goingToApp = location == '/home' ||
            location == '/calendar' ||
            location == '/settings' ||
            location == '/entry/new' ||
            location == '/entry/edit';

        if (!signedIn && !goingToAuth) return '/login';
        if (signedIn && goingToAuth) return '/home';
        if (signedIn && !goingToApp && !goingToAuth) return '/home';
        return null;
      },
      routes: [
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AppShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/calendar',
                  builder: (context, state) => const CalendarScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/entry/new',
          builder: (context, state) => const EntryEditorScreen(),
        ),
        GoRoute(
          path: '/entry/edit',
          builder: (context, state) => EntryEditorScreen(
            existing: state.extra as Entry,
          ),
        ),
      ],
    );
  }
}

