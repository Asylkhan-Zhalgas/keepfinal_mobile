import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final branchIndex = navigationShell.currentIndex;
    // NavigationBar indices: 0 diary, 1 calendar, 2 add, 3 settings
    final selectedIndex = switch (branchIndex) {
      0 => 0,
      1 => 1,
      2 => 3,
      _ => 0,
    };

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          if (index == 2) {
            context.push('/entry/new');
            return;
          }

          // Map nav indices to branch indices: 0 diary, 1 calendar, 3 settings
          final nextBranch = switch (index) {
            0 => 0,
            1 => 1,
            3 => 2,
            _ => 0,
          };
          navigationShell.goBranch(
            nextBranch,
            initialLocation: nextBranch == branchIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Дневник',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Календарь',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Добавить',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}

