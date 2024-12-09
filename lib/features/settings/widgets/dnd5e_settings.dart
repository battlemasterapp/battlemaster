import 'package:async/async.dart';
import 'package:battlemaster/api/providers/dnd5e_engine_provider.dart';
import 'package:battlemaster/api/providers/game_engine_provider.dart';
import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/settings/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/system_settings_provider.dart';

class Dnd5eSettingsWidget extends StatelessWidget {
  const Dnd5eSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final systemSettings = context.read<SystemSettingsProvider>();
    final gameSettings = context.select<SystemSettingsProvider, Dnd5eSettings>(
        (state) => state.dnd5eSettings);
    return Column(
      children: [
        SwitchListTile.adaptive(
          value: gameSettings.enabled,
          onChanged: (value) async {
            await systemSettings
                .set5eSettings(gameSettings.copyWith(enabled: value));
            // ignore: use_build_context_synchronously
            await context.read<AnalyticsService>().logEvent(
              'toggle_5e_bestiary',
              props: {'enabled': value.toString()},
            );
          },
          title: Text(
            localization.dnd5e_settings_title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          subtitle: Text(localization.dnd5e_settings_bestiary_toggle),
        ),
        AnimatedSwitcher(
          duration: 300.ms,
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          child: gameSettings.enabled ? _Dnd5eSettings() : SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _Dnd5eSettings extends StatelessWidget {
  _Dnd5eSettings();

  final AsyncCache _cache = AsyncCache.ephemeral();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final engineProvider = context.watch<Dnd5eEngineProvider>();
    final loadingData =
        engineProvider.currentStatus == GameEngineProviderStatus.loading;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(localization.reload_data_title),
          subtitle: Text(localization.reload_data_description),
          trailing: loadingData
              ? CircularProgressIndicator.adaptive()
              : ElevatedButton(
                  onPressed: () => _cache.fetch(() async {
                    await engineProvider.fetchData(forceRefresh: true);
                  }),
                  child: Text(localization.reload_button),
                ),
        ),
      ],
    );
  }
}
