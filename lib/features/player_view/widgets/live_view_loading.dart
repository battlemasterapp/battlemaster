import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LiveViewLoading extends StatelessWidget {
  const LiveViewLoading({
    super.key,
    this.onLeave,
  });

  final VoidCallback? onLeave;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator.adaptive(),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onLeave,
          child: Text(localization.cancel_button),
        ),
      ],
    );
  }
}
