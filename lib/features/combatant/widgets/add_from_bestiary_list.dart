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
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: localization.search_input,
            hintText: localization.search_input,
            prefixIcon: Icon(MingCute.search_fill),
            suffix: IconButton(
              onPressed: () => setState(() => _searchController.clear()),
              icon: Icon(MingCute.close_fill),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        Builder(builder: (context) {
          final filteredCombatants = widget.combatants.where((combatant) {
            return combatant.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
          }).toList();

          if (filteredCombatants.isEmpty) {
            return Center(
              child: Text(localization.no_results_search),
            );
          }

          return Expanded(
            child: BestiaryList(
              combatants: filteredCombatants,
              onCombatantSelected: widget.onCombatantSelected,
            ),
          );
        }),
      ],
    );
  }
}
