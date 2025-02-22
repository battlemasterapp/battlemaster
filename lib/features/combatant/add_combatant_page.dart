import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/bestiaries/providers/custom_bestiary_provider.dart';
import 'package:battlemaster/features/combatant/add_combatant_landscape.dart';
import 'package:battlemaster/features/combatant/add_combatants_portrait.dart';
import 'package:battlemaster/features/encounters/models/encounter_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'models/combatant.dart';

class AddCombatantParams {
  final EncounterType encounterType;

  AddCombatantParams({
    required this.encounterType,
  });
}

class AddCombatantPage extends StatefulWidget {
  const AddCombatantPage({
    super.key,
    required this.params,
  });

  final AddCombatantParams params;

  @override
  State<AddCombatantPage> createState() => _AddCombatantPageState();
}

class _AddCombatantPageState extends State<AddCombatantPage> {
  Map<Combatant, int> _combatants = {};

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    return ChangeNotifierProvider<CustomBestiaryProvider>(
      create: (context) => CustomBestiaryProvider(context.read<AppDatabase>()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.add_combatant_title),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (isMobile) {
                return AddCombatantsPortraitPage(
                  combatants: _combatants,
                  showGroupReminder:
                      widget.params.encounterType == EncounterType.encounter,
                  onCombatantsChanged: (combatants) => setState(() {
                    _combatants = combatants;
                  }),
                  onCombatantsAdded: (combatants) {
                    setState(() {
                      combatants.forEach((combatant, count) {
                        _combatants.update(
                          combatant,
                          (value) => value + count,
                          ifAbsent: () => count,
                        );
                      });
                    });
                  },
                );
              }

              return AddCombatantPageLandscape(
                combatants: _combatants,
                showGroupReminder:
                    widget.params.encounterType == EncounterType.encounter,
                onCombatantsChanged: (combatants) => setState(() {
                  _combatants = combatants;
                }),
                onCombatantsAdded: (combatants) {
                  setState(() {
                    combatants.forEach((combatant, count) {
                      _combatants.update(
                        combatant,
                        (value) => value + count,
                        ifAbsent: () => count,
                      );
                    });
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
