import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'presentation/auth/login/login_screen.dart';
import 'presentation/auth/register/register_screen.dart';
import 'presentation/entries/entries_controller.dart';
import 'presentation/entries/entry_editor/entry_editor_screen.dart';
import 'presentation/home/home_screen.dart';
import 'models/entry.dart';
import 'presentation/state/session_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionController()..init()),
        ChangeNotifierProvider(create: (_) => EntriesController()..load()),
      ],
      child: Builder(
        builder: (context) {
          final sessionController = context.watch<SessionController>();

          final router = GoRouter(
            initialLocation: '/login',
            refreshListenable: sessionController,
            redirect: (context, state) {
              final signedIn = sessionController.isSignedIn;
              final location = state.matchedLocation;
              final goingToAuth = location == '/register' || location == '/login';

              if (!signedIn && !goingToAuth) return '/login';
              if (signedIn && goingToAuth) return '/home';
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
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
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

          return MaterialApp.router(
            title: 'KeepFinal Diary',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: true,
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}

