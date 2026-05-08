import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'data/entries/hive_entries_repository.dart';
import 'domain/entries/usecases/delete_entry.dart';
import 'domain/entries/usecases/get_entries.dart';
import 'domain/entries/usecases/save_entry.dart';
import 'presentation/entries/entries_controller.dart';
import 'presentation/state/session_controller.dart';
import 'navigation/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionController()..init()),
        ChangeNotifierProvider(
          create: (_) {
            final repo = HiveEntriesRepository();
            return EntriesController(
              getEntries: GetEntries(repo),
              saveEntry: SaveEntry(repo),
              deleteEntry: DeleteEntry(repo),
            )..load();
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final sessionController = context.watch<SessionController>();
          final router = AppRouter.create(sessionController);

          return MaterialApp.router(
            title: 'KeepFinal Diary',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: true,
              textTheme: GoogleFonts.montserratTextTheme(),
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}

