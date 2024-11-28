import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

class LiveViewDisconnected extends StatelessWidget {
  const LiveViewDisconnected({
    super.key,
    this.onLeave,
  });

  final VoidCallback? onLeave;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return LayoutBuilder(builder: (context, layout) {
      final iconSize = min(128, layout.maxHeight / 3).toDouble();
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FIcon(
            GI.GiBreakingChain,
            size: iconSize,
            color: Theme.of(context).iconTheme.color ??
                Theme.of(context).textTheme.bodyMedium?.color ??
                Colors.black,
          ),
          const SizedBox(height: 16),
          Text(
            localization.live_view_ended,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onLeave,
            child: Text(localization.leave_button),
          ),
        ],
      );
    });
  }
}
