import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:toastification/toastification.dart';

class EncounterCodeDialog extends StatelessWidget {
  const EncounterCodeDialog({
    super.key,
    required this.code,
    this.onEndShare,
  });

  final String code;
  final VoidCallback? onEndShare;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(localization.encounter_code_dialog_title),
          IconButton(
              onPressed: Navigator.of(context).pop,
              icon: Icon(MingCute.close_fill)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(localization.encounter_code_dialog_description),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey.shade300,
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SelectableText(
                  code,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.grey.shade800,
                      ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    toastification.show(
                      type: ToastificationType.success,
                      style: ToastificationStyle.fillColored,
                      autoCloseDuration: 3.seconds,
                      showProgressBar: false,
                      title: Text(localization.copied_to_clipboard),
                    );
                  },
                  color: Colors.grey.shade800,
                  icon: Icon(MingCute.copy_2_fill),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onEndShare?.call();
            },
            child: Text(localization.end_live_share_button),
          ),
        ],
      ),
    );
  }
}
