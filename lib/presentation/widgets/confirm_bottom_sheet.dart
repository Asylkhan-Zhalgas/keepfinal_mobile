import 'package:flutter/material.dart';

Future<bool> showConfirmBottomSheet({
  required BuildContext context,
  required String title,
  required String confirmText,
  String cancelText = 'Отмена',
  bool destructive = false,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _ConfirmBottomSheet(
      title: title,
      confirmText: confirmText,
      cancelText: cancelText,
      destructive: destructive,
    ),
  );

  return result ?? false;
}

class _ConfirmBottomSheet extends StatelessWidget {
  final String title;
  final String confirmText;
  final String cancelText;
  final bool destructive;

  const _ConfirmBottomSheet({
    required this.title,
    required this.confirmText,
    required this.cancelText,
    required this.destructive,
  });

  @override
  Widget build(BuildContext context) {
    final confirmStyle = destructive
        ? FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          )
        : FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: confirmStyle,
              child: Text(confirmText),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(cancelText),
            ),
          ],
        ),
      ),
    );
  }
}

