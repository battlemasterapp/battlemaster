import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/encounters/providers/encounters_provider.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:battlemaster/features/groups/group_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../encounters/models/encounter.dart';
import '../../encounters/models/encounter_type.dart';
import '../models/combatant.dart';

class AddGroupCombatants extends StatefulWidget {
  const AddGroupCombatants({
    super.key,
    this.onGroupSelected,
  });

  final ValueChanged<List<Combatant>>? onGroupSelected;

  @override
  State<AddGroupCombatants> createState() => _AddGroupCombatantsState();
}

class _AddGroupCombatantsState extends State<AddGroupCombatants> {
  String _search = "";

  @override
  Widget build(BuildContext context) {
    final state = context.read<EncountersProvider>();
    final localization = AppLocalizations.of(context)!;
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: localization.search_input,
            prefixIcon: Icon(MingCute.search_fill),
          ),
          onChanged: (value) => setState(() => _search = value),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: StreamBuilder<List<Encounter>>(
              stream: state.watchEncounters(EncounterType.group),
              builder: (context, snapshot) {
                final groups = snapshot.data ?? [];
                final filteredGroups = groups
                    .where((group) => group.name.contains(_search))
                    .toList();
                if (filteredGroups.isEmpty) {
                  return const _EmptyState();
                }
                return ListView.builder(
                  itemCount: filteredGroups.length,
                  itemBuilder: (context, index) {
                    final group = filteredGroups[index];
                    return ListTile(
                      tileColor: index.isEven
                          ? Theme.of(context).primaryColor.withOpacity(.2)
                          : Theme.of(context).primaryColor.withOpacity(.1),
                      title: Text(group.name),
                      subtitle:
                          Text(group.combatants.map((c) => c.name).join(", ")),
                      onTap: () {
                        widget.onGroupSelected?.call(group.combatants);
                      },
                    );
                  },
                );
              }),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(localization.empty_groups_list),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () async {
            final encounter = Encounter(
              name: AppLocalizations.of(context)!.new_group_name,
              type: EncounterType.group,
              combatants: [],
              engine: GameEngineType.pf2e,
            );
            final created = await context
                .read<EncountersProvider>()
                .addEncounter(encounter);
            // ignore: use_build_context_synchronously
            context.pushNamed(
              "group",
              pathParameters: {'groupId': created.id.toString()},
              extra: GroupDetailPageParams(encounter: created),
            );
            // ignore: use_build_context_synchronously
            await context.read<AnalyticsService>().logEvent(
              'create-encounter',
              props: {'type': EncounterType.group.toString()},
            );
          },
          child: Text(localization.create_group_cta),
        )
      ],
    );
  }
}
