import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:battlemaster/features/encounter_tracker/providers/share_encounter_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class GoLiveButton extends StatelessWidget {
  const GoLiveButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final live =
        context.select<ShareEncounterNotifier, bool>((state) => state.live);
    if (live) {
      return ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .fade(duration: 750.ms, curve: Curves.easeInOutQuad),
            ),
            const SizedBox(width: 6),
            Text(localization.live_button),
          ],
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(localization.live_share_button),
    );
  }
}
