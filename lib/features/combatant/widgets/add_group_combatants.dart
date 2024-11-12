import 'package:battlemaster/features/encounters/providers/encounters_provider.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.search_input,
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
                  return Text(AppLocalizations.of(context)!.empty_groups_list);
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
