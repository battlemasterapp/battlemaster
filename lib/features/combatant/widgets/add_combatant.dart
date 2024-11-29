import 'package:battlemaster/api/providers/dnd5e_engine_provider.dart';
import 'package:battlemaster/api/providers/pf2e_engine_provider.dart';
import 'package:battlemaster/api/services/pf2e_bestiary_service.dart';
import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/bestiaries/models/custom_bestiary.dart';
import 'package:battlemaster/features/bestiaries/providers/custom_bestiary_provider.dart';
import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/widgets/add_custom_combatant.dart';
import 'package:battlemaster/features/combatant/widgets/add_from_bestiary_list.dart';
import 'package:battlemaster/features/combatant/widgets/add_group_combatants.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AddCombatant extends StatelessWidget {
  const AddCombatant({
    super.key,
    required this.onCombatantsAdded,
    this.showGroupReminder = false,
  });

  final ValueChanged<Map<Combatant, int>> onCombatantsAdded;
  final bool showGroupReminder;

  @override
  Widget build(BuildContext context) {
    final systemSettings = context.watch<SystemSettingsProvider>();
    var localization = AppLocalizations.of(context)!;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    final tabs = <Tab, Widget>{
      if (systemSettings.dnd5eSettings.enabled)
        Tab(
          text: localization.dnd5e_toggle_button,
          icon: Icon(FontAwesome.dragon_solid),
        ): AddFromBestiaryList(
          combatants: context.read<Dnd5eEngineProvider>().bestiary,
          onCombatantSelected: (combatant) async {
            onCombatantsAdded({combatant: 1});
            await context.read<AnalyticsService>().logEvent('add_5e_combatant');
          },
        ),
      if (systemSettings.pf2eSettings.enabled)
        Tab(
          text: localization.pf2e_toggle_button,
          icon: Icon(FontAwesome.dragon_solid),
        ): AddFromBestiaryList(
          combatants: context.read<Pf2eEngineProvider>().bestiary,
          onCombatantSelected: (combatant) async {
            onCombatantsAdded({combatant: 1});
            await context
                .read<AnalyticsService>()
                .logEvent('add_pf2e_combatant');
          },
        ),
      Tab(
        text: localization.custom_bestiary_toggle_button,
        icon: Icon(MingCute.paw_fill),
      ): StreamBuilder<List<CustomBestiary>>(
          stream: context.read<CustomBestiaryProvider>().watchAll(),
          builder: (context, snapshot) {
            final data = snapshot.data ?? [];
            return AddFromBestiaryList(
              combatants: data.fold(
                [],
                (combatants, bestiary) =>
                    combatants..addAll(bestiary.combatants),
              )..sort((a, b) => a.name.compareTo(b.name)),
              onCombatantSelected: (combatant) async {
                onCombatantsAdded({combatant: 1});
                await context
                    .read<AnalyticsService>()
                    .logEvent('add_custom_bestiary_combatant');
              },
            );
          }),
      Tab(
        text: localization.groups_toggle_button,
        icon: Icon(MingCute.group_fill),
      ): AddGroupCombatants(
        onGroupSelected: (combatants) async {
          onCombatantsAdded(
            combatants.fold<Map<Combatant, int>>(
              {},
              (map, combatant) {
                map[combatant] = 1;
                return map;
              },
            ),
          );
          await context
              .read<AnalyticsService>()
              .logEvent('add_group_combatants');
        },
      ),
      Tab(
        text: localization.custom_combatant_toggle_button,
        icon: Icon(MingCute.edit_fill),
      ): AddCustomCombatant(
        showGroupReminder: showGroupReminder,
        onCombatantAdded: (combatant) async {
          onCombatantsAdded({combatant: 1});
          await context
              .read<AnalyticsService>()
              .logEvent('add_custom_combatant');
        },
      ),
    };

    return DefaultTabController(
      length: tabs.length,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TabBar(
              tabs: tabs.keys.toList(),
              isScrollable: isMobile && tabs.length > 3,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: tabs.values.toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
