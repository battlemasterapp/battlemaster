import 'dart:math';

import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:battlemaster/features/encounters/models/encounter_type.dart';
import 'package:battlemaster/features/encounters/providers/encounters_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

import '../../engines/models/game_engine_type.dart';
import '../models/combatant.dart';
import '../models/combatant_type.dart';

class CustomCombatantForm extends StatefulWidget {
  const CustomCombatantForm({
    super.key,
    this.onSubmit,
    this.showGroupReminder = false,
    this.baseCombatant,
  });

  final ValueChanged<Combatant>? onSubmit;
  final bool showGroupReminder;
  final Combatant? baseCombatant;

  @override
  State<CustomCombatantForm> createState() => _CustomCombatantFormState();
}

class _CustomCombatantFormState extends State<CustomCombatantForm> {
  final _formKey = GlobalKey<FormState>();
  late Combatant combatant;

  @override
  void initState() {
    super.initState();
    combatant = widget.baseCombatant?.copyWith() ?? _getBaseCombatant();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  initialValue: combatant.name,
                  decoration:
                      InputDecoration(labelText: localization.name_label),
                  onChanged: (value) {
                    combatant = combatant.copyWith(name: value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.combatant_name_validation_text;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue:
                      combatant.maxHp > 0 ? combatant.maxHp.toString() : null,
                  onChanged: (value) {
                    final hp = int.tryParse(value);
                    combatant = combatant.copyWith(
                      maxHp: hp,
                      currentHp: combatant.id.isEmpty ? hp : null,
                    );
                  },
                  decoration: InputDecoration(labelText: localization.hp_label),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: combatant.armorClass > 0
                      ? combatant.armorClass.toString()
                      : null,
                  onChanged: (value) {
                    combatant =
                        combatant.copyWith(armorClass: int.tryParse(value));
                  },
                  decoration: InputDecoration(labelText: localization.ac_label),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  initialValue: combatant.initiativeModifier > 0
                      ? combatant.initiativeModifier.toString()
                      : null,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    combatant = combatant.copyWith(
                      initiativeModifier: int.tryParse(value),
                    );
                  },
                  decoration: InputDecoration(
                      labelText: localization.initiative_modifier_label),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButton<CombatantType>(
            hint: Text(localization.combatant_type_dropdown_label),
            value: combatant.type,
            onChanged: (value) {
              setState(() {
                combatant = combatant.copyWith(type: value);
              });
            },
            items: CombatantType.values.map(
              (type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FIcon(
                        type.icon,
                        color: Theme.of(context).iconTheme.color ??
                            Theme.of(context).textTheme.bodyMedium?.color ??
                            Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(type.translate(localization)),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  if (combatant.id.isNotEmpty) {
                    combatant = combatant.copyWith(
                      currentHp: min(combatant.currentHp, combatant.maxHp),
                    );
                  }
                  widget.onSubmit?.call(combatant);
                  _formKey.currentState!.reset();
                  combatant = _getBaseCombatant();
                },
                child: Text(localization.save_button),
              ),
            ],
          ),
          if (widget.showGroupReminder) const _GroupReminder(),
        ],
      ),
    );
  }

  Combatant _getBaseCombatant() {
    return Combatant(
      id: '',
      name: '',
      currentHp: 0,
      maxHp: 0,
      armorClass: 0,
      initiativeModifier: 0,
      type: CombatantType.monster,
      engineType: GameEngineType.custom,
    );
  }
}

class _GroupReminder extends StatelessWidget {
  const _GroupReminder();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      children: [
        const Divider(),
        Text(
          localization.create_group_reminder,
          style: Theme.of(context).textTheme.bodySmall,
        ),
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
                .createEncounter(encounter);
            // ignore: use_build_context_synchronously
            context.pushNamed(
              "group",
              pathParameters: {"groupId": created.id.toString()},
            );
            // ignore: use_build_context_synchronously
            await context.read<AnalyticsService>().logEvent(
              'create-encounter',
              props: {'type': EncounterType.group.toString()},
            );
          },
          child: Text(localization.create_group_cta),
        ),
      ],
    );
  }
}
