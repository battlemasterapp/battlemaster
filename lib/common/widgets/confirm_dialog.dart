import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    this.description,
  });

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          children: [
            if (description != null) Text(description!),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => context.pop(false),
          child: Text(localization.no_button),
        ),
        ElevatedButton(
          onPressed: () => context.pop(true),
          child: Text(localization.yes_button),
        ),
      ],
    );
  }
}
