import 'package:flutter/material.dart';

class EncounterCodeDialog extends StatelessWidget {
  const EncounterCodeDialog({
    super.key,
    required this.code,
  });

  final String code;

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    return AlertDialog(
      title: Text('Encounter Code'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Share this code with your friends to join the encounter:'),
          const SizedBox(height: 8),
          SelectableText(
            code,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
