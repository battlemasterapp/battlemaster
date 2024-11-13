import 'package:async/async.dart';
import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class DangerousSettings extends StatefulWidget {
  const DangerousSettings({super.key});

  @override
  State<DangerousSettings> createState() => _DangerousSettingsState();
}

class _DangerousSettingsState extends State<DangerousSettings> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      children: [
        SwitchListTile.adaptive(
          value: _enabled,
          onChanged: (value) => setState(() {
            _enabled = value;
          }),
          title: Text(
            localization.danger_zone_settings_title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          subtitle: Text(localization.danger_zone_settings_subtitle),
        ),
        AnimatedSwitcher(
          duration: 300.ms,
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          child: _enabled ? const _DangerZone() : SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _DangerZone extends StatelessWidget {
  const _DangerZone();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      children: [
        ListTile(
          leading: Icon(MingCute.folder_delete_fill),
          title: Text(localization.delete_data_title),
          subtitle: Text(localization.delete_data_subtitle),
          trailing: _EraseDataButton(),
        ),
      ],
    );
  }
}

class _EraseDataButton extends StatefulWidget {
  const _EraseDataButton();

  @override
  State<_EraseDataButton> createState() => __EraseDataButtonState();
}

class __EraseDataButtonState extends State<_EraseDataButton> {
  final AsyncCache _cache = AsyncCache.ephemeral();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    if (_loading) {
      return CircularProgressIndicator.adaptive();
    }

    return ElevatedButton(
      onPressed: () => _cache.fetch(() async {
        setState(() {
          _loading = true;
        });
        await Future.wait([
          context.read<AppDatabase>().eraseEncounters(),
          context.read<SystemSettingsProvider>().reset(),
        ]);
        setState(() {
          _loading = false;
        });
      }),
      child: Text(localization.delete_data_button),
    );
  }
}
