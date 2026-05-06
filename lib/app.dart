import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
            initialLocation: '/register',
            refreshListenable: sessionController,
            redirect: (context, state) {
              final signedIn = sessionController.isSignedIn;
              final goingToRegister = state.matchedLocation == '/register';

              if (!signedIn && !goingToRegister) return '/register';
              if (signedIn && goingToRegister) return '/home';
              return null;
            },
            routes: [
              GoRoute(
                path: '/register',
                builder: (context, state) => const RegisterScreen(),
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

