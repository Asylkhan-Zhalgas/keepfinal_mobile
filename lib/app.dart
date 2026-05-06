import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'presentation/auth/login/login_screen.dart';
import 'presentation/auth/register/register_screen.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/state/session_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionController()..init()),
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

