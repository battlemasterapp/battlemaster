import 'package:async/async.dart';
import 'package:battlemaster/api/providers/game_engine_provider.dart';
import 'package:battlemaster/api/providers/pf2e_engine_provider.dart';
import 'package:battlemaster/extensions/string_extension.dart';
import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/settings/models/settings.dart';
import 'package:battlemaster/features/settings/widgets/pf2e_bestiary_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../providers/system_settings_provider.dart';

class Pf2eSettingsWidget extends StatelessWidget {
  const Pf2eSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final systemSettings = context.read<SystemSettingsProvider>();
    final gameSettings = context.select<SystemSettingsProvider, PF2eSettings>(
        (state) => state.pf2eSettings);
    return Column(
      children: [
        SwitchListTile.adaptive(
          value: gameSettings.enabled,
          onChanged: (value) async {
            await systemSettings.setPF2eSettings(
              gameSettings.copyWith(enabled: value),
            );
            // ignore: use_build_context_synchronously
            await context.read<AnalyticsService>().logEvent(
              'toggle_pf2e_bestiary',
              props: {'enabled': value.toString()},
            );
          },
          title: Text(
            localization.pf2e_settings_title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          subtitle: Text(localization.pf2e_settings_bestiary_toggle),
        ),
        AnimatedSwitcher(
          duration: 300.ms,
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          child: gameSettings.enabled ? _Pf2eSettings() : SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _Pf2eSettings extends StatelessWidget {
  _Pf2eSettings();

  final AsyncCache _cache = AsyncCache.ephemeral();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final engineProvider = context.watch<Pf2eEngineProvider>();
    final gameSettings = context.select<SystemSettingsProvider, PF2eSettings>(
        (state) => state.pf2eSettings);
    final selectedBestiaries = gameSettings.bestiaries
        .map((b) => b.split('-').map((s) => s.capitalize()).join(' '))
        .toList()
      ..sort();
    final bestiariesString = selectedBestiaries.join(', ');
    final subtitle =
        "${localization.bestiary_settings_description}\n${localization.selected_bestiaries} $bestiariesString";
    final loadingData =
        engineProvider.currentStatus == GameEngineProviderStatus.loading;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(MingCute.refresh_2_fill),
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
        ListTile(
          leading: Icon(MingCute.book_3_fill),
          title: Text(localization.bestiary_settings_title),
          subtitle: Text(subtitle),
          isThreeLine: true,
          trailing: Icon(MingCute.right_fill),
          onTap: () async {
            final selected = await showDialog(
              context: context,
              builder: (context) => const Pf2eBestiaryDialog(),
            );

            if (selected == null) {
              return;
            }

            // ignore: use_build_context_synchronously
            await context.read<SystemSettingsProvider>().setPF2eSettings(
                  gameSettings.copyWith(bestiaries: selected),
                );
          },
        ),
      ],
    );
  }
}
