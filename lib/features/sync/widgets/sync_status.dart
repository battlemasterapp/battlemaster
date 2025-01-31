import 'dart:math';

import 'package:battlemaster/features/auth/providers/auth_provider.dart';
import 'package:battlemaster/features/encounters/providers/encounters_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

class SyncStatus extends StatelessWidget {
  const SyncStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final localization = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
      child: LayoutBuilder(
        builder: (context, layout) {
          final iconSize = min(128, layout.maxHeight / 3).toDouble();
          if (authProvider.isAnonymous) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FIcon(
                  GI.GiHoodedFigure,
                  size: iconSize,
                  color: Theme.of(context).iconTheme.color ??
                      Theme.of(context).textTheme.bodyMedium?.color ??
                      Colors.black,
                ),
                const SizedBox(height: 16),
                Text(
                  localization.sync_status_anonymous_login,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(localization.sync_status_anonymous_login_description),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await authProvider.logout();
                  },
                  child: Text(localization.logout_button),
                ),
              ],
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FIcon(
                GI.GiTabletopPlayers,
                size: iconSize,
                color: Theme.of(context).iconTheme.color ??
                    Theme.of(context).textTheme.bodyMedium?.color ??
                    Colors.black,
              ),
              Text(
                localization.sync_status_logged_in(
                    authProvider.userModel!.getStringValue('name')),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(localization.sync_status_logged_in_description),
              const SizedBox(height: 16),
              const SyncButton(),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () async {
                  await authProvider.logout();
                },
                child: Text(localization.logout_button),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SyncButton extends StatefulWidget {
  const SyncButton({super.key});

  @override
  State<SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends State<SyncButton> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _loading = true;
        });
        await context.read<EncountersProvider>().syncAllEncounters();
        setState(() {
          _loading = false;
        });
      },
      child: _loading
          ? CircularProgressIndicator.adaptive()
          : Text(localization.sync_status_sync_button),
    );
  }
}
