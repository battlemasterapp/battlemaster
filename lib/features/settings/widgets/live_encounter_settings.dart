import 'package:battlemaster/features/settings/models/encounter_settings.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class LiveEncounterSettingsWidget extends StatelessWidget {
  const LiveEncounterSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    final settings = context.read<SystemSettingsProvider>();

    return FutureBuilder<bool>(
      future: settings.isFeatureEnabled(LiveEncounterSettings.featureKey),
      initialData:
          settings.encounterSettings.liveEncounterSettings.featureEnabled,
      builder: (context, snapshot) {
        final featureEnabled = snapshot.data ?? false;

        if (!featureEnabled) {
          return const SizedBox.shrink();
        }

        final liveSettings =
            context.select<SystemSettingsProvider, LiveEncounterSettings>(
          (state) => state.encounterSettings.liveEncounterSettings,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            SwitchListTile.adaptive(
              value: liveSettings.userEnabled,
              onChanged: (value) {
                context.read<SystemSettingsProvider>().setLiveEncounterSettings(
                    liveSettings.copyWith(userEnabled: value));
              },
              title: Text(
                'Visão do jogador',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            AnimatedSwitcher(
              duration: 300.ms,
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              child: liveSettings.userEnabled
                  ? const _LiveEncounterSettings()
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}

class _LiveEncounterSettings extends StatelessWidget {
  const _LiveEncounterSettings();

  @override
  Widget build(BuildContext context) {
    final settings =
        context.select<SystemSettingsProvider, LiveEncounterSettings>(
      (state) => state.encounterSettings.liveEncounterSettings,
    );
    // FIXME: textos
    return Column(
      children: [
        SwitchListTile.adaptive(
          value: settings.showMonsterHealth,
          onChanged: (value) {
            context.read<SystemSettingsProvider>().setLiveEncounterSettings(
                settings.copyWith(showMonsterHealth: value));
          },
          secondary: Icon(MingCute.heartbeat_fill),
          title: Text('Indicativo de vida dos monstros'),
          subtitle:
              Text('Mostra um indicativo de quão machucado um monstro está.'),
        ),
        SwitchListTile.adaptive(
          value: settings.hideFutureCombatants,
          onChanged: (value) {
            context.read<SystemSettingsProvider>().setLiveEncounterSettings(
                settings.copyWith(hideFutureCombatants: value));
          },
          secondary: Icon(MingCute.eye_fill),
          title: Text('Esconder monstros futuros'),
          subtitle: Text(
              'Esconde o nome e informações de monstros que não agiram ainda.'),
        ),
      ],
    );
  }
}
