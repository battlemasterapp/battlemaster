import 'package:battlemaster/features/player_view/providers/player_view_notifier.dart';
import 'package:battlemaster/features/player_view/widgets/live_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PlayerViewPage extends StatelessWidget {
  const PlayerViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final liveViewState = context.watch<PlayerViewNotifier>();
    final code = liveViewState.code;
    if (code == null || code.length < 6) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              localization.type_encounter_code,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Pinput(
              length: 6,
              keyboardType: TextInputType.text,
              onCompleted: (value) {
                liveViewState.subscribe(code: value.toUpperCase());
              },
            ),
          ],
        ),
      );
    }

    return LiveView(
      onLeave: () {
        liveViewState.unsubscribe();
      },
    );
  }
}
