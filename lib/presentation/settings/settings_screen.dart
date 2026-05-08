import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/confirm_bottom_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Выйти'),
            onTap: () async {
              final ok = await showConfirmBottomSheet(
                context: context,
                title: 'Выйти из аккаунта?',
                confirmText: 'Выйти',
                destructive: true,
              );
              if (!ok) return;
              if (!context.mounted) return;
              await Supabase.instance.client.auth.signOut();
              if (!context.mounted) return;
            },
          ),
        ],
      ),
    );
  }
}
