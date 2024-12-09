import 'package:battlemaster/features/combatant/widgets/bestiary_list/bestiary_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';

import '../models/combatant.dart';

class AddFromBestiaryList extends StatefulWidget {
  const AddFromBestiaryList({
    super.key,
    this.combatants = const [],
    this.onCombatantSelected,
  });

  final List<Combatant> combatants;
  final ValueChanged<Combatant>? onCombatantSelected;

  @override
  State<AddFromBestiaryList> createState() => _AddFromBestiaryListState();
}

class _AddFromBestiaryListState extends State<AddFromBestiaryList> {
  String _searchTerm = "";

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    final filteredCombatants = widget.combatants.where((combatant) {
      return combatant.name.toLowerCase().contains(_searchTerm.toLowerCase());
    }).toList();

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: localization.search_input,
            hintText: localization.search_input,
            prefixIcon: Icon(MingCute.search_fill),
          ),
          onChanged: (value) => setState(() => _searchTerm = value),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: BestiaryList(
            combatants: filteredCombatants,
            onCombatantSelected: widget.onCombatantSelected,
          ),
        ),
      ],
    );
  }
}
